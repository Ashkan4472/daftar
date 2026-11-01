import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db/database.dart';
import 'state.dart';

const _keep = Object();

/// Immutable transaction filter. Equal filters share one provider instance.
class TxFilter {
  const TxFilter({
    this.ym,
    this.from,
    this.to,
    this.kind,
    this.categoryIds,
    this.tagId,
    this.accountId,
    this.personId,
    this.marked = false,
    this.uncategorized = false,
    this.toReview = false,
    this.hasGap = false,
    this.query = '',
  });

  final int? ym;
  final DateTime? from, to;
  final TxKind? kind;
  final List<int>? categoryIds;
  final int? tagId, accountId, personId;
  final bool marked, uncategorized, toReview, hasGap;
  final String query;

  TxFilter copyWith({
    Object? ym = _keep,
    Object? from = _keep,
    Object? to = _keep,
    Object? kind = _keep,
    Object? categoryIds = _keep,
    Object? tagId = _keep,
    Object? accountId = _keep,
    Object? personId = _keep,
    bool? marked,
    bool? uncategorized,
    bool? toReview,
    bool? hasGap,
    String? query,
  }) =>
      TxFilter(
        ym: identical(ym, _keep) ? this.ym : ym as int?,
        from: identical(from, _keep) ? this.from : from as DateTime?,
        to: identical(to, _keep) ? this.to : to as DateTime?,
        kind: identical(kind, _keep) ? this.kind : kind as TxKind?,
        categoryIds: identical(categoryIds, _keep) ? this.categoryIds : categoryIds as List<int>?,
        tagId: identical(tagId, _keep) ? this.tagId : tagId as int?,
        accountId: identical(accountId, _keep) ? this.accountId : accountId as int?,
        personId: identical(personId, _keep) ? this.personId : personId as int?,
        marked: marked ?? this.marked,
        uncategorized: uncategorized ?? this.uncategorized,
        toReview: toReview ?? this.toReview,
        hasGap: hasGap ?? this.hasGap,
        query: query ?? this.query,
      );

  /// Number of active user-facing filters (month is not counted).
  int get activeCount => [
        kind != null, categoryIds != null, tagId != null, accountId != null, personId != null,
        marked, uncategorized, toReview, hasGap,
      ].where((b) => b).length;

  String get _key =>
      '$ym|$from|$to|$kind|$categoryIds|$tagId|$accountId|$personId|$marked|$uncategorized|$toReview|$hasGap|$query';

  @override
  bool operator ==(Object other) => other is TxFilter && other._key == _key;
  @override
  int get hashCode => _key.hashCode;
}

class TxRow {
  const TxRow(this.tx, this.account, this.category, this.tagIds, [this.partAmount]);
  final Transaction tx;

  /// Set when a category filter matched one part of a split transaction: that part's Rial.
  final int? partAmount;
  final Account account;
  final Category? category;
  final List<int> tagIds;
}

/// FTS5 MATCH expression from free text: each word as a quoted prefix term.
String? ftsQuery(String q) {
  final words = RegExp(r'[\p{L}\p{N}]+', unicode: true)
      .allMatches(normalizeSms(q))
      .map((m) => m[0]!)
      .toList();
  if (words.isEmpty) return null;
  return words.map((w) => '"$w"*').join(' ');
}

Expression<bool> _where(AppDb db, TxFilter f) {
  final t = db.transactions;
  var e = t.deletedAt.isNull();
  if (f.ym != null) e &= t.jalaliYm.equals(f.ym!);
  if (f.from != null) e &= t.occurredAt.isBiggerOrEqualValue(f.from!);
  if (f.to != null) e &= t.occurredAt.isSmallerThanValue(f.to!);
  if (f.kind != null) e &= t.kind.equals(f.kind!.name);
  if (f.categoryIds != null) {
    e &= t.categoryId.isIn(f.categoryIds!) |
        CustomExpression<bool>('EXISTS (SELECT 1 FROM tx_parts p WHERE p.transaction_id = transactions.id '
            'AND p.category_id IN (${f.categoryIds!.join(',')}))');
  }
  if (f.accountId != null) e &= t.accountId.equals(f.accountId!);
  if (f.marked) e &= t.marked.equals(true);
  if (f.uncategorized) e &= t.categoryId.isNull() & t.kind.equals(TxKind.transfer.name).not();
  if (f.toReview) {
    e &= t.needsReview.equals(true) |
        (t.categoryId.isNull() & t.kind.equals(TxKind.transfer.name).not());
  }
  if (f.hasGap) e &= t.balanceGap.isNotNull() & t.balanceGap.equals(0).not();
  if (f.tagId != null) {
    e &= CustomExpression<bool>('EXISTS (SELECT 1 FROM transaction_tags tt '
        'WHERE tt.transaction_id = transactions.id AND tt.tag_id = ${f.tagId!})');
  }
  if (f.personId != null) {
    e &= CustomExpression<bool>('EXISTS (SELECT 1 FROM splits s '
        'WHERE s.transaction_id = transactions.id AND s.person_id = ${f.personId!})');
  }
  final fts = ftsQuery(f.query);
  if (fts != null) {
    // fts contains only letters, digits, quotes, * and spaces by construction.
    e &= CustomExpression<bool>("transactions.id IN (SELECT rowid FROM tx_fts WHERE tx_fts MATCH '$fts')");
  }
  return e;
}

class Repo {
  Repo(this.db);
  final AppDb db;

  static final _tagIds = CustomExpression<String>(
      '(SELECT group_concat(tag_id) FROM transaction_tags WHERE transaction_id = transactions.id)');

  JoinedSelectStatement<HasResultSet, dynamic> query(TxFilter f, {int? limit}) {
    final q = db.select(db.transactions).join([
      innerJoin(db.accounts, db.accounts.id.equalsExp(db.transactions.accountId)),
      leftOuterJoin(db.categories, db.categories.id.equalsExp(db.transactions.categoryId)),
      // With a category filter a split transaction shows once per matching part.
      if (f.categoryIds != null)
        leftOuterJoin(
            db.txParts, db.txParts.transactionId.equalsExp(db.transactions.id) & db.txParts.categoryId.isIn(f.categoryIds!)),
    ])
      ..addColumns([_tagIds])
      ..where(_where(db, f))
      ..orderBy([OrderingTerm.desc(db.transactions.occurredAt), OrderingTerm.desc(db.transactions.id)]);
    if (limit != null) q.limit(limit);
    return q;
  }

  TxRow _row(TypedResult r) => TxRow(
        r.readTable(db.transactions),
        r.readTable(db.accounts),
        r.readTableOrNull(db.categories),
        [for (final s in (r.read(_tagIds) ?? '').split(',')) if (s.isNotEmpty) int.parse(s)],
        r.readTableOrNull(db.txParts)?.amount,
      );

  Stream<List<TxRow>> watch(TxFilter f, int limit) => query(f, limit: limit).watch().map((rs) => rs.map(_row).toList());

  Future<TxRow?> get(int id) async {
    final q = query(const TxFilter())..where(db.transactions.id.equals(id));
    final rs = await q.get();
    return rs.isEmpty ? null : _row(rs.first);
  }

  Stream<TxRow?> watchOne(int id) {
    final q = query(const TxFilter())..where(db.transactions.id.equals(id));
    return q.watch().map((rs) => rs.isEmpty ? null : _row(rs.first));
  }

  Future<int> count(TxFilter f) async {
    final c = db.transactions.id.count();
    final q = db.selectOnly(db.transactions)..addColumns([c])..where(_where(db, f));
    return (await q.getSingle()).read(c)!;
  }

  // ---- mutations -----------------------------------------------------------

  Future<void> _update(List<int> ids, TransactionsCompanion c) =>
      (db.update(db.transactions)..where((t) => t.id.isIn(ids)))
          .write(c.copyWith(updatedAt: Value(DateTime.now())));

  /// Picking a single category undoes any category split.
  Future<void> setCategory(List<int> ids, int? categoryId) => db.transaction(() async {
        await (db.delete(db.txParts)..where((p) => p.transactionId.isIn(ids))).go();
        await _update(ids, TransactionsCompanion(categoryId: Value(categoryId), needsReview: const Value(false)));
      });

  /// Splits one transaction across categories ([parts]: category id, positive Rial).
  /// Fewer than two parts just sets a plain category.
  Future<void> setParts(int id, List<(int, int)> parts) {
    if (parts.length < 2) return setCategory([id], parts.firstOrNull?.$1);
    return db.transaction(() async {
      await (db.delete(db.txParts)..where((p) => p.transactionId.equals(id))).go();
      for (final (cat, amount) in parts) {
        await db.into(db.txParts).insert(TxPartsCompanion.insert(transactionId: id, categoryId: cat, amount: amount));
      }
      final top = parts.reduce((a, b) => b.$2 > a.$2 ? b : a);
      await _update([id], TransactionsCompanion(categoryId: Value(top.$1), needsReview: const Value(false)));
    });
  }

  Future<void> setNote(int id, String note) => _update([id], TransactionsCompanion(note: Value(note)));

  Future<void> setMarked(List<int> ids, bool v) => _update(ids, TransactionsCompanion(marked: Value(v)));

  Future<void> setExcluded(int id, bool v) => _update([id], TransactionsCompanion(excluded: Value(v)));

  Future<void> softDelete(List<int> ids) =>
      _update(ids, TransactionsCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restore(List<int> ids) => _update(ids, const TransactionsCompanion(deletedAt: Value(null)));

  // Tag rows are read through a sub-select the row stream cannot see, so each
  // change also touches the transaction to make open screens refresh.
  Future<void> addTag(List<int> ids, int tagId) async {
    await db.batch((b) => b.insertAll(
          db.transactionTags,
          [for (final id in ids) TransactionTagsCompanion.insert(transactionId: id, tagId: tagId)],
          mode: InsertMode.insertOrIgnore,
        ));
    await _update(ids, const TransactionsCompanion());
  }

  Future<void> removeTag(List<int> ids, int tagId) async {
    await (db.delete(db.transactionTags)..where((t) => t.transactionId.isIn(ids) & t.tagId.equals(tagId))).go();
    await _update(ids, const TransactionsCompanion());
  }

  Future<int> addManual({
    required int amount,
    required int accountId,
    required DateTime at,
    int? categoryId,
    String note = '',
    Set<int> tagIds = const {},
  }) async {
    final id = await db.into(db.transactions).insert(TransactionsCompanion.insert(
          accountId: accountId,
          amount: amount,
          occurredAt: at,
          jalaliYm: jalaliYm(at),
          kind: amount < 0 ? TxKind.expense : TxKind.income,
          source: TxSource.manual,
          categoryId: Value(categoryId),
          note: Value(note),
        ));
    for (final t in tagIds) {
      await addTag([id], t);
    }
    return id;
  }

  /// Manual transactions can change amount/date; SMS ones are facts.
  Future<void> updateManual(int id, {required int amount, required DateTime at}) => db.transaction(() async {
        // A category split no longer adds up once the amount changes.
        await db.customStatement(
            'DELETE FROM tx_parts WHERE transaction_id = ?1 AND (SELECT SUM(amount) FROM tx_parts WHERE transaction_id = ?1) != ?2',
            [id, amount.abs()]);
        await _update(
          [id],
          TransactionsCompanion(
            amount: Value(amount),
            occurredAt: Value(at),
            jalaliYm: Value(jalaliYm(at)),
            kind: Value(amount < 0 ? TxKind.expense : TxKind.income),
          ),
        );
      });

  Future<int> trashCount() async {
    final c = db.transactions.id.count();
    final q = db.selectOnly(db.transactions)..addColumns([c])..where(db.transactions.deletedAt.isNotNull());
    return (await q.getSingle()).read(c)!;
  }

  /// Permanently removes items trashed more than [days] ago.
  Future<void> purgeTrash({int days = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final ids = (await (db.select(db.transactions)..where((t) => t.deletedAt.isSmallerThanValue(cutoff))).get())
        .map((t) => t.id)
        .toList();
    if (ids.isEmpty) return;
    await (db.delete(db.transactionTags)..where((t) => t.transactionId.isIn(ids))).go();
    await (db.delete(db.splits)..where((t) => t.transactionId.isIn(ids))).go();
    await (db.delete(db.txParts)..where((t) => t.transactionId.isIn(ids))).go();
    await (db.delete(db.transactions)..where((t) => t.id.isIn(ids))).go();
  }

  Future<String?> setting(String key) async =>
      (await (db.select(db.settings)..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> putSetting(String key, String value) =>
      db.into(db.settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  // ---- categories / tags ----------------------------------------------------

  Future<int> saveCategory({
    int? id,
    required String name,
    required CategoryKind kind,
    int? parentId,
    required String icon,
    required int color,
    bool renamed = true,
  }) async {
    if (id != null) {
      await (db.update(db.categories)..where((c) => c.id.equals(id))).write(CategoriesCompanion(
        // A renamed built-in stops following the UI language.
        name: renamed ? Value(name) : const Value.absent(),
        nameKey: renamed ? const Value(null) : const Value.absent(),
        kind: Value(kind), parentId: Value(parentId), icon: Value(icon), color: Value(color),
      ));
      return id;
    }
    final n = await db.categories.count().getSingle();
    return db.into(db.categories).insert(CategoriesCompanion.insert(
          name: name, kind: kind, parentId: Value(parentId), icon: icon, color: color, sort: Value(n),
        ));
  }

  Future<void> archiveCategory(int id, bool v) =>
      (db.update(db.categories)..where((c) => c.id.equals(id) | c.parentId.equals(id)))
          .write(CategoriesCompanion(archived: Value(v)));

  /// Moves everything from [from] into [into], then archives [from].
  Future<void> mergeCategory(int from, int into) => db.transaction(() async {
        await (db.update(db.transactions)..where((t) => t.categoryId.equals(from)))
            .write(TransactionsCompanion(categoryId: Value(into), updatedAt: Value(DateTime.now())));
        await (db.update(db.txParts)..where((p) => p.categoryId.equals(from))).write(TxPartsCompanion(categoryId: Value(into)));
        await (db.update(db.categories)..where((c) => c.parentId.equals(from)))
            .write(CategoriesCompanion(parentId: Value(into)));
        await archiveCategory(from, true);
      });

  Future<int> saveTag({int? id, required String name, required String icon, required int color, bool renamed = true}) async {
    if (id != null) {
      await (db.update(db.tags)..where((t) => t.id.equals(id))).write(TagsCompanion(
        name: renamed ? Value(name) : const Value.absent(),
        nameKey: renamed ? const Value(null) : const Value.absent(),
        icon: Value(icon), color: Value(color),
      ));
      return id;
    }
    return db.into(db.tags).insert(TagsCompanion.insert(name: name, icon: icon, color: color));
  }

  Future<void> deleteTag(int id) async {
    await (db.delete(db.transactionTags)..where((t) => t.tagId.equals(id))).go();
    await (db.delete(db.tags)..where((t) => t.id.equals(id))).go();
  }

  Future<bool> accountNumberTaken(String number, {int? exceptId}) async {
    final row = await (db.select(db.accounts)..where((a) => a.number.equals(number))).get();
    return row.any((a) => a.id != exceptId);
  }

  Future<int> saveAccount({
    int? id,
    required String name,
    required String icon,
    required int color,
    AccountKind kind = AccountKind.cash,
    int? bankId,
    String? number,
    int? opening,
  }) async {
    final num = (number ?? '').trim().isEmpty ? null : number!.trim();
    if (id != null) {
      await (db.update(db.accounts)..where((a) => a.id.equals(id))).write(AccountsCompanion(
        name: Value(name), icon: Value(icon), color: Value(color),
        bankId: Value(bankId), number: Value(num), openingBalance: Value.absentIfNull(opening),
      ));
      return id;
    }
    final n = await db.accounts.count().getSingle();
    return db.into(db.accounts).insert(AccountsCompanion.insert(
          name: name, kind: kind, icon: icon, color: color, bankId: Value(bankId), number: Value(num),
          openingBalance: Value(opening ?? 0), sort: Value(n)));
  }

  /// Tell Daftar the real balance at [at]. Pass null to go back to automatic.
  Future<void> setBalance(int accountId, int? value, DateTime? at) =>
      (db.update(db.accounts)..where((a) => a.id.equals(accountId)))
          .write(AccountsCompanion(balanceSet: Value(value), balanceSetAt: Value(value == null ? null : at)));

  Future<void> archiveAccount(int id, bool v) =>
      (db.update(db.accounts)..where((a) => a.id.equals(id))).write(AccountsCompanion(archived: Value(v)));

  /// Moves [amount] (positive Rial) between two accounts as a linked pair of transfer rows.
  Future<void> addTransfer({required int from, required int to, required int amount, required DateTime at, String note = ''}) =>
      db.transaction(() async {
        final group = DateTime.now().millisecondsSinceEpoch ~/ 1000; // far from proposal ids
        for (final (acc, signed) in [(from, -amount), (to, amount)]) {
          await db.into(db.transactions).insert(TransactionsCompanion.insert(
                accountId: acc, amount: signed, occurredAt: at, jalaliYm: jalaliYm(at),
                kind: TxKind.transfer, source: TxSource.manual, note: Value(note),
                transferGroupId: Value(group)));
        }
      });
}

final repoProvider = Provider<Repo>((ref) => Repo(ref.watch(dbProvider)));

typedef TxQuery = (TxFilter, int);

final txListProvider = StreamProvider.family<List<TxRow>, TxQuery>(
    (ref, q) => ref.watch(repoProvider).watch(q.$1, q.$2));

final txOneProvider = StreamProvider.family<TxRow?, int>((ref, id) => ref.watch(repoProvider).watchOne(id));

final txCountProvider = StreamProvider.family<int, TxFilter>((ref, f) {
  final db = ref.watch(dbProvider);
  final c = db.transactions.id.count();
  final q = db.selectOnly(db.transactions)..addColumns([c])..where(_where(db, f));
  return q.watchSingle().map((r) => r.read(c)!);
});

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.categories)..orderBy([(c) => OrderingTerm.asc(c.sort), (c) => OrderingTerm.asc(c.id)])).watch();
});

final tagsProvider = StreamProvider<List<Tag>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.tags)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();
});

final accountsProvider = StreamProvider<List<Account>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.accounts)..orderBy([(a) => OrderingTerm.asc(a.sort), (a) => OrderingTerm.asc(a.id)])).watch();
});

final banksProvider = StreamProvider<List<Bank>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.banks)..orderBy([(b) => OrderingTerm.asc(b.id)])).watch();
});

final peopleProvider = StreamProvider<List<Person>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.people)..orderBy([(p) => OrderingTerm.asc(p.name)])).watch();
});

/// id -> Category lookup for rendering rows.
final categoryMapProvider = Provider<Map<int, Category>>((ref) =>
    {for (final c in ref.watch(categoriesProvider).value ?? const <Category>[]) c.id: c});

final tagMapProvider =
    Provider<Map<int, Tag>>((ref) => {for (final t in ref.watch(tagsProvider).value ?? const <Tag>[]) t.id: t});
