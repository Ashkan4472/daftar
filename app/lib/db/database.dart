import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed.dart';

part 'database.g.dart';

enum AccountKind { bank, cash }

enum TxKind { expense, income, transfer }

enum TxSource { sms, manual, import }

enum SmsStatus { parsed, unmatched, ignored, error }

enum CategoryKind { expense, income }

enum ReminderTarget { transaction, person, recurring }

mixin _Id on Table {
  IntColumn get id => integer().autoIncrement()();
}

class Banks extends Table with _Id {
  TextColumn get code => text().unique()();
  TextColumn get nameEn => text()();
  TextColumn get nameFa => text()();
  TextColumn get icon => text().withDefault(const Constant('bank'))();
}

class Accounts extends Table with _Id {
  TextColumn get name => text()();
  IntColumn get bankId => integer().nullable().references(Banks, #id)();

  /// Account/card number exactly as it appears in SMS.
  TextColumn get number => text().nullable()();
  TextColumn get kind => textEnum<AccountKind>()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  IntColumn get openingBalance => integer().withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get sort => integer().withDefault(const Constant(0))();

  /// Balance the user typed in, valid as of [balanceSetAt]. Null = automatic.
  IntColumn get balanceSet => integer().nullable()();
  DateTimeColumn get balanceSetAt => dateTime().nullable()();
}

class SmsSenders extends Table with _Id {
  TextColumn get address => text().unique()();
  IntColumn get bankId => integer().nullable().references(Banks, #id)();
  BoolColumn get ignored => boolean().withDefault(const Constant(false))();
}

@DataClassName('SmsTemplateRow')
class SmsTemplates extends Table with _Id {
  /// Stable id, e.g. `resalat.v1` for built-ins.
  TextColumn get code => text().unique()();
  IntColumn get bankId => integer().nullable().references(Banks, #id)();
  TextColumn get sender => text().nullable()();
  TextColumn get pattern => text()();
  TextColumn get sample => text().nullable()();
  BoolColumn get builtin => boolean().withDefault(const Constant(false))();
  BoolColumn get verified => boolean().withDefault(const Constant(false))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get priority => integer().withDefault(const Constant(0))();
}

@TableIndex(name: 'raw_sms_status', columns: {#status})
@DataClassName('RawSmsRow')
class RawSms extends Table with _Id {
  TextColumn get address => text()();
  TextColumn get body => text()();
  DateTimeColumn get receivedAt => dateTime()();
  TextColumn get hash => text().unique()();
  TextColumn get status => textEnum<SmsStatus>()();
  TextColumn get templateCode => text().nullable()();
}

class Categories extends Table with _Id {
  IntColumn get parentId => integer().nullable().references(Categories, #id)();
  TextColumn get kind => textEnum<CategoryKind>()();

  /// User-visible name. Built-ins also carry [nameKey] for translation until renamed.
  TextColumn get name => text()();
  TextColumn get nameKey => text().nullable()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  BoolColumn get builtin => boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get sort => integer().withDefault(const Constant(0))();
}

class Tags extends Table with _Id {
  TextColumn get name => text().unique()();
  TextColumn get nameKey => text().nullable()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  BoolColumn get builtin => boolean().withDefault(const Constant(false))();
}

@TableIndex(name: 'tx_time', columns: {#occurredAt, #id})
@TableIndex(name: 'tx_account_time', columns: {#accountId, #occurredAt})
@TableIndex(name: 'tx_month_category', columns: {#jalaliYm, #categoryId})
@TableIndex(name: 'tx_category', columns: {#categoryId})
@TableIndex(name: 'tx_deleted', columns: {#deletedAt})
class Transactions extends Table with _Id {
  IntColumn get accountId => integer().references(Accounts, #id)();

  /// Signed Rial. Negative = money out.
  IntColumn get amount => integer()();
  DateTimeColumn get occurredAt => dateTime()();

  /// Jalali year*100+month, denormalized for monthly reports.
  IntColumn get jalaliYm => integer()();
  IntColumn get balanceAfter => integer().nullable()();
  TextColumn get kind => textEnum<TxKind>()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get marked => boolean().withDefault(const Constant(false))();
  BoolColumn get excluded => boolean().withDefault(const Constant(false))();
  BoolColumn get needsReview => boolean().withDefault(const Constant(false))();
  TextColumn get source => textEnum<TxSource>()();
  IntColumn get rawSmsId => integer().nullable().references(RawSms, #id)();
  IntColumn get transferGroupId => integer().nullable()();
  IntColumn get recurringId => integer().nullable()();

  /// Rial the balance moved that no SMS explains; 0 = consistent, null = unknown.
  IntColumn get balanceGap => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class TransactionTags extends Table {
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();
  @override
  Set<Column> get primaryKey => {transactionId, tagId};
}

/// Category split of one transaction: parts are positive Rial and add up to its |amount|.
/// Transactions.categoryId then holds the largest part's category.
@TableIndex(name: 'part_tx', columns: {#transactionId})
class TxParts extends Table with _Id {
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get amount => integer()();
}

@DataClassName('Person')
class People extends Table with _Id {
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  TextColumn get note => text().withDefault(const Constant(''))();
}

@TableIndex(name: 'split_person', columns: {#personId})
@DataClassName('SplitRow')
class Splits extends Table with _Id {
  IntColumn get transactionId => integer().nullable().references(Transactions, #id)();
  IntColumn get personId => integer().references(People, #id)();

  /// Positive = they owe me, negative = I owe them.
  IntColumn get share => integer()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get occurredAt => dateTime()();
}

class Settlements extends Table with _Id {
  IntColumn get personId => integer().references(People, #id)();

  /// Positive = they paid me.
  IntColumn get amount => integer()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get transactionId => integer().nullable().references(Transactions, #id)();
}

class Budgets extends Table with _Id {
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get monthlyLimit => integer()();
  IntColumn get fromYm => integer()();
  IntColumn get toYm => integer().nullable()();
}

class Recurrings extends Table with _Id {
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get expectedAmount => integer()();
  IntColumn get periodDays => integer()();
  DateTimeColumn get nextDue => dateTime()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  BoolColumn get dismissed => boolean().withDefault(const Constant(false))();
}

class Reminders extends Table with _Id {
  TextColumn get targetType => textEnum<ReminderTarget>()();
  IntColumn get targetId => integer()();
  DateTimeColumn get at => dateTime()();
  TextColumn get body => text().withDefault(const Constant(''))();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}

@DataClassName('Setting')
@DataClassName('InboxItem')
class InboxItems extends Table with _Id {
  /// capture | reminder | budget | leak | summary | transfer
  TextColumn get kind => text()();
  TextColumn get title => text()();
  TextColumn get body => text().withDefault(const Constant(''))();

  /// Where tapping goes: `tx:12`, `person:3`, `review`, `reports`...
  TextColumn get payload => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
}

/// Two transactions that look like one transfer between own accounts.
class TransferProposals extends Table with _Id {
  IntColumn get outTxId => integer().references(Transactions, #id)();
  IntColumn get inTxId => integer().references(Transactions, #id)();

  /// pending | confirmed | dismissed
  TextColumn get status => text().withDefault(const Constant('pending'))();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  Banks, Accounts, SmsSenders, SmsTemplates, RawSms, Categories, Tags,
  Transactions, TransactionTags, People, Splits, Settlements, Budgets,
  Recurrings, Reminders, InboxItems, TransferProposals, Settings, TxParts,
])
class AppDb extends _$AppDb {
  AppDb([QueryExecutor? e]) : super(e ?? driftDatabase(name: 'daftar'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await createSearchIndex();
          await seedDefaults(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 5) await m.createTable(txParts);
          if (from < 4) {
            await m.addColumn(accounts, accounts.balanceSet);
            await m.addColumn(accounts, accounts.balanceSetAt);
          }
          if (from < 3) {
            await m.createTable(inboxItems);
            await m.createTable(transferProposals);
          }
          if (from < 2) {
            await createSearchIndex();
            await customStatement(
                "INSERT INTO tx_fts(rowid, note, body) SELECT t.id, t.note, COALESCE(r.body, '') "
                'FROM transactions t LEFT JOIN raw_sms r ON r.id = t.raw_sms_id');
          }
        },
        beforeOpen: (_) async {
          await customStatement('PRAGMA foreign_keys = ON');
          // The background sync worker opens the same file from another isolate.
          await customStatement('PRAGMA journal_mode = WAL');
          await customStatement('PRAGMA busy_timeout = 8000');
        },
      );

  /// Full-text index over note + raw SMS body, kept in sync by triggers.
  // ponytail: stores a second copy of each SMS body; make it contentless if size matters.
  Future<void> createSearchIndex() async {
    await customStatement("CREATE VIRTUAL TABLE IF NOT EXISTS tx_fts USING fts5(note, body, tokenize='unicode61')");
    await customStatement('''CREATE TRIGGER IF NOT EXISTS tx_fts_ai AFTER INSERT ON transactions BEGIN
      INSERT INTO tx_fts(rowid, note, body) VALUES (new.id, new.note,
        COALESCE((SELECT body FROM raw_sms WHERE id = new.raw_sms_id), '')); END''');
    await customStatement('''CREATE TRIGGER IF NOT EXISTS tx_fts_au AFTER UPDATE OF note ON transactions BEGIN
      UPDATE tx_fts SET note = new.note WHERE rowid = new.id; END''');
    await customStatement('''CREATE TRIGGER IF NOT EXISTS tx_fts_ad AFTER DELETE ON transactions BEGIN
      DELETE FROM tx_fts WHERE rowid = old.id; END''');
  }
}
