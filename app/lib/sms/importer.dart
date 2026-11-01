import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../db/database.dart';
import '../theme/palette.dart';

class SmsMessage {
  const SmsMessage(this.address, this.body, this.receivedAt);
  final String address;
  final String body;
  final DateTime receivedAt;
}

class ImportResult {
  int scanned = 0, added = 0, unmatched = 0, duplicates = 0;
}

/// Worth keeping as "unmatched" for the template builder; everything else
/// (OTPs, ads, personal SMS) is skipped and never stored.
final _looksFinancial = RegExp(r'مانده|موجودی|برداشت|واریز|مبلغ|ریال|[+-][\d,]{4,}');

class SmsImporter {
  SmsImporter(this.db);
  final AppDb db;
  static const _channel = MethodChannel('daftar/sms');

  static const _system = MethodChannel('daftar/system');

  Future<bool> ensurePermission() async =>
      await _system.invokeMethod<bool>('requestSmsPermission') ?? false;

  /// Imports inbox SMS in [from, to). Safe to repeat: duplicates are skipped.
  Future<ImportResult> importRange(
    DateTime from,
    DateTime to, {
    void Function(int done, int total)? onProgress,
    bool Function()? isCancelled,
  }) async {
    final args = {'from': from.millisecondsSinceEpoch, 'to': to.millisecondsSinceEpoch};
    final total = await _channel.invokeMethod<int>('count', args) ?? 0;
    final result = ImportResult();
    final touched = <int>{};
    const page = 500;
    for (var offset = 0; offset < total; offset += page) {
      if (isCancelled?.call() ?? false) break;
      final rows = await _channel.invokeListMethod<Map>(
              'query', {...args, 'offset': offset, 'limit': page}) ??
          const [];
      final msgs = [
        for (final r in rows)
          SmsMessage(r['address'] as String? ?? '', r['body'] as String? ?? '',
              DateTime.fromMillisecondsSinceEpoch(r['date'] as int)),
      ];
      touched.addAll(await importMessages(msgs, result));
      onProgress?.call(offset + rows.length, total);
    }
    for (final a in touched) {
      await recomputeBalanceGaps(a);
    }
    return result;
  }

  /// Stores and parses [msgs] in one DB transaction. Returns touched account ids.
  Future<Set<int>> importMessages(List<SmsMessage> msgs, ImportResult result) {
    return db.transaction(() async {
      final templates = await _templates();
      final banks = {for (final b in await db.select(db.banks).get()) b.code: b.id};
      final ignored = {
        for (final s in await (db.select(db.smsSenders)..where((s) => s.ignored)).get()) s.address
      };
      final hashes = {for (final m in msgs) smsHash(m.address, m.body, m.receivedAt): m};
      final existing = await (db.selectOnly(db.rawSms)
            ..addColumns([db.rawSms.hash])
            ..where(db.rawSms.hash.isIn(hashes.keys)))
          .map((r) => r.read(db.rawSms.hash)!)
          .get();
      final touched = <int>{};

      for (final MapEntry(key: hash, value: m) in hashes.entries) {
        result.scanned++;
        if (existing.contains(hash)) {
          result.duplicates++;
          continue;
        }
        if (ignored.contains(m.address)) continue;

        final parsed = parseSms(m.address, m.body, m.receivedAt,
            templates: templates.map((t) => t.$1).toList(), useHeuristic: true);
        // Heuristic hits only count when the SMS carries a balance; otherwise
        // ads like "50,000 تومان خرید" would become transactions.
        final usable = parsed != null &&
            (parsed.templateId != 'heuristic' || parsed.balance != null);

        if (!usable) {
          if (_looksFinancial.hasMatch(normalizeSms(m.body))) {
            await db.into(db.rawSms).insert(RawSmsCompanion.insert(
                  address: m.address, body: m.body, receivedAt: m.receivedAt,
                  hash: hash, status: SmsStatus.unmatched,
                ));
            result.unmatched++;
          }
          continue;
        }

        final bankCode = templates
            .where((t) => t.$1.id == parsed.templateId)
            .map((t) => t.$1.bankCode)
            .firstOrNull;
        final bankId = bankCode == null ? null : banks[bankCode];
        await _linkSender(m.address, bankId);
        final accountId = await _resolveAccount(parsed.account ?? 'sms:${m.address}', bankId);

        final rawId = await db.into(db.rawSms).insert(RawSmsCompanion.insert(
              address: m.address, body: m.body, receivedAt: m.receivedAt,
              hash: hash, status: SmsStatus.parsed, templateCode: Value(parsed.templateId),
            ));
        await db.into(db.transactions).insert(TransactionsCompanion.insert(
              accountId: accountId,
              amount: parsed.amount,
              occurredAt: parsed.occurredAt,
              jalaliYm: jalaliYm(parsed.occurredAt),
              balanceAfter: Value(parsed.balance),
              kind: parsed.amount < 0 ? TxKind.expense : TxKind.income,
              source: TxSource.sms,
              rawSmsId: Value(rawId),
              needsReview: Value(parsed.needsReview),
              note: Value(parsed.description ?? ''),
            ));
        touched.add(accountId);
        result.added++;
      }
      return touched;
    });
  }

  Future<List<(SmsTemplate, int?)>> _templates() async {
    final rows = await (db.select(db.smsTemplates)
          ..where((t) => t.enabled)
          ..orderBy([(t) => OrderingTerm.desc(t.priority)]))
        .get();
    final banks = {for (final b in await db.select(db.banks).get()) b.id: b.code};
    return [
      for (final r in rows)
        (
          SmsTemplate(
            id: r.code, pattern: r.pattern, sender: r.sender,
            bankCode: banks[r.bankId], verified: r.verified,
          ),
          r.bankId,
        ),
    ];
  }

  Future<void> _linkSender(String address, int? bankId) async {
    await db.into(db.smsSenders).insert(
          SmsSendersCompanion.insert(address: address, bankId: Value(bankId)),
          onConflict: DoUpdate(
            (old) => SmsSendersCompanion.custom(bankId: coalesce([old.bankId, Variable(bankId)])),
            target: [db.smsSenders.address],
          ),
        );
  }

  Future<int> _resolveAccount(String number, int? bankId) async {
    final found = await (db.select(db.accounts)..where((a) => a.number.equals(number)))
        .getSingleOrNull();
    if (found != null) return found.id;
    final bank = bankId == null
        ? null
        : await (db.select(db.banks)..where((b) => b.id.equals(bankId))).getSingle();
    // Dotted account numbers (10.11228735.1) are short and recognisable; card
    // numbers are shortened to their last 4 digits.
    final digits = number.replaceAll(RegExp(r'\D'), '');
    final label = number.contains('.') || number.startsWith('sms:')
        ? number.replaceFirst('sms:', '')
        : '••${digits.length > 4 ? digits.substring(digits.length - 4) : digits}';
    final count = await db.accounts.count().getSingle();
    return db.into(db.accounts).insert(AccountsCompanion.insert(
          name: '${bank?.nameEn ?? 'Bank'} $label',
          bankId: Value(bankId),
          number: Value(number),
          kind: AccountKind.bank,
          icon: 'bank:regular',
          color: pickerPalette[count % pickerPalette.length],
        ));
  }

  /// balance_gap = balance_after − (previous balance_after + amount), per account.
  // ponytail: recomputes the whole account; scope to a time window if imports get slow.
  Future<void> recomputeBalanceGaps(int accountId) => db.customStatement('''
    WITH o AS (
      SELECT id, balance_after - (LAG(balance_after) OVER w + amount) AS gap
      FROM transactions
      WHERE account_id = ?1 AND deleted_at IS NULL AND balance_after IS NOT NULL
      WINDOW w AS (ORDER BY occurred_at, id)
    )
    UPDATE transactions SET balance_gap = o.gap FROM o WHERE o.id = transactions.id
  ''', [accountId]);
}
