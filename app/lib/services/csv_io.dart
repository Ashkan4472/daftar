import 'package:core/core.dart';
import 'package:drift/drift.dart';

import '../db/database.dart';
import '../repo.dart';
import '../theme/palette.dart';

/// Exports every transaction matching [f], oldest first, in chunks.
Future<(String csv, int count)> exportTransactions(AppDb db, TxFilter f) async {
  final repo = Repo(db);
  final cats = {for (final c in await db.select(db.categories).get()) c.id: c};
  final tags = {for (final t in await db.select(db.tags).get()) t.id: t.name};
  final rows = <ExportRow>[];
  const chunk = 5000;
  for (var offset = 0;; offset += chunk) {
    final q = repo.query(f)..limit(chunk, offset: offset);
    final got = await q.get();
    if (got.isEmpty) break;
    final ids = [for (final r in got) r.readTable(db.transactions).id];
    final peopleRows = await db.customSelect(
      'SELECT s.transaction_id AS t, p.name AS n FROM splits s JOIN people p ON p.id = s.person_id WHERE s.transaction_id IN (${ids.join(',')})',
    ).get();
    final people = <int, List<String>>{};
    for (final r in peopleRows) {
      people.putIfAbsent(r.read<int>('t'), () => []).add(r.read<String>('n'));
    }
    for (final r in got) {
      final t = r.readTable(db.transactions);
      final c = cats[t.categoryId];
      final parent = cats[c?.parentId];
      final tagIds = (r.read(CustomExpression<String>('(SELECT group_concat(tag_id) FROM transaction_tags WHERE transaction_id = transactions.id)')) ?? '')
          .split(',')
          .where((s) => s.isNotEmpty);
      rows.add(ExportRow(
        at: t.occurredAt,
        account: r.readTable(db.accounts).name,
        kind: t.kind.name,
        amount: t.amount,
        category: (parent ?? c)?.name ?? '',
        subcategory: parent == null ? '' : c!.name,
        tags: [for (final id in tagIds) tags[int.parse(id)] ?? ''],
        note: t.note,
        people: people[t.id] ?? const [],
        balanceAfter: t.balanceAfter,
      ));
    }
    if (got.length < chunk) break;
  }
  rows.sort((a, b) => a.at.compareTo(b.at));
  return (exportCsv(rows), rows.length);
}

class CsvMapping {
  CsvMapping({this.date, this.time, this.amount, this.note, this.category, this.subcategory, this.account, this.tags, this.balance, this.amountInToman = false, this.invertSign = false, this.defaultAccountId});
  int? date, time, amount, note, category, subcategory, account, tags, balance;
  bool amountInToman, invertSign;
  int? defaultAccountId;

  /// Auto-map the headers of a Daftar export.
  static CsvMapping? fromHeader(List<String> h) {
    if (!exportHeader.every(h.contains)) return null;
    int i(String n) => h.indexOf(n);
    return CsvMapping(
      date: i('date_gregorian'), time: i('time'), amount: i('amount_rial'), note: i('note'),
      category: i('category'), subcategory: i('subcategory'), account: i('account'), tags: i('tags'), balance: i('balance_after'),
    );
  }
}

class CsvImportResult {
  int added = 0, skipped = 0;
}

/// Imports parsed CSV [rows] (without the header). Rows that already exist
/// (same account, amount and minute) and unreadable rows are skipped.
Future<CsvImportResult> importCsvRows(AppDb db, List<List<String>> rows, CsvMapping m) async {
  final res = CsvImportResult();
  final accountCache = {for (final a in await db.select(db.accounts).get()) a.name.toLowerCase(): a.id};
  final catCache = <String, int>{};
  for (final c in await db.select(db.categories).get()) {
    catCache['${c.parentId ?? 0}|${c.name.toLowerCase()}'] = c.id;
  }
  final tagCache = {for (final t in await db.select(db.tags).get()) t.name.toLowerCase(): t.id};
  final fallbackAccount = m.defaultAccountId ?? (await (db.select(db.accounts)..where((a) => a.kind.equals(AccountKind.cash.name))).get()).first.id;

  String cell(List<String> r, int? i) => i == null || i < 0 || i >= r.length ? '' : r[i].trim();

  Future<int> category(String name, int? parent, bool expense) async {
    final key = '${parent ?? 0}|${name.toLowerCase()}';
    final hit = catCache[key];
    if (hit != null) return hit;
    final n = await db.categories.count().getSingle();
    final id = await db.into(db.categories).insert(CategoriesCompanion.insert(
        name: name, kind: expense ? CategoryKind.expense : CategoryKind.income, parentId: Value(parent),
        icon: 'tag:regular', color: pickerPalette[n % pickerPalette.length], sort: Value(n)));
    return catCache[key] = id;
  }

  await db.transaction(() async {
    for (final r in rows) {
      final at = parseFlexibleDate(cell(r, m.date), cell(r, m.time));
      final raw = normalizeSms(cell(r, m.amount)).replaceAll(',', '');
      final value = num.tryParse(raw.replaceAll(RegExp(r'[^\d.\-+]'), ''));
      if (at == null || value == null || value == 0) {
        res.skipped++;
        continue;
      }
      var amount = (value * (m.amountInToman ? 10 : 1)).round() * (m.invertSign ? -1 : 1);
      final accName = cell(r, m.account);
      final accountId = accName.isEmpty
          ? fallbackAccount
          : accountCache[accName.toLowerCase()] ?? (accountCache[accName.toLowerCase()] = await db.into(db.accounts).insert(AccountsCompanion.insert(
              name: accName, kind: AccountKind.cash, icon: 'wallet:regular', color: pickerPalette[accountCache.length % pickerPalette.length])));
      final dup = await (db.select(db.transactions)
            ..where((t) => t.accountId.equals(accountId) & t.amount.equals(amount) & t.occurredAt.equals(DateTime(at.year, at.month, at.day, at.hour, at.minute)) & t.deletedAt.isNull())
            ..limit(1))
          .get();
      if (dup.isNotEmpty) {
        res.skipped++;
        continue;
      }
      int? catId;
      final cat = cell(r, m.category), sub = cell(r, m.subcategory);
      if (cat.isNotEmpty) {
        final parent = await category(cat, null, amount < 0);
        catId = sub.isEmpty ? parent : await category(sub, parent, amount < 0);
      }
      final id = await db.into(db.transactions).insert(TransactionsCompanion.insert(
            accountId: accountId, amount: amount, occurredAt: at, jalaliYm: jalaliYm(at),
            kind: amount < 0 ? TxKind.expense : TxKind.income, source: TxSource.import,
            categoryId: Value(catId), note: Value(cell(r, m.note)),
            balanceAfter: Value(int.tryParse(cell(r, m.balance))),
          ));
      for (final tn in cell(r, m.tags).split('|').where((s) => s.trim().isNotEmpty)) {
        final key = tn.trim().toLowerCase();
        final tid = tagCache[key] ?? (tagCache[key] = await db.into(db.tags).insert(TagsCompanion.insert(name: tn.trim(), icon: 'hash:regular', color: pickerPalette[4])));
        await db.into(db.transactionTags).insert(TransactionTagsCompanion.insert(transactionId: id, tagId: tid), mode: InsertMode.insertOrIgnore);
      }
      res.added++;
    }
  });
  return res;
}
