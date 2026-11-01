// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BanksTable extends Banks with TableInfo<$BanksTable, Bank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFaMeta = const VerificationMeta('nameFa');
  @override
  late final GeneratedColumn<String> nameFa = GeneratedColumn<String>(
    'name_fa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bank'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, nameEn, nameFa, icon];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'banks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bank> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_fa')) {
      context.handle(
        _nameFaMeta,
        nameFa.isAcceptableOrUnknown(data['name_fa']!, _nameFaMeta),
      );
    } else if (isInserting) {
      context.missing(_nameFaMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bank(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameFa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fa'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
    );
  }

  @override
  $BanksTable createAlias(String alias) {
    return $BanksTable(attachedDatabase, alias);
  }
}

class Bank extends DataClass implements Insertable<Bank> {
  final int id;
  final String code;
  final String nameEn;
  final String nameFa;
  final String icon;
  const Bank({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameFa,
    required this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_en'] = Variable<String>(nameEn);
    map['name_fa'] = Variable<String>(nameFa);
    map['icon'] = Variable<String>(icon);
    return map;
  }

  BanksCompanion toCompanion(bool nullToAbsent) {
    return BanksCompanion(
      id: Value(id),
      code: Value(code),
      nameEn: Value(nameEn),
      nameFa: Value(nameFa),
      icon: Value(icon),
    );
  }

  factory Bank.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bank(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameFa: serializer.fromJson<String>(json['nameFa']),
      icon: serializer.fromJson<String>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameFa': serializer.toJson<String>(nameFa),
      'icon': serializer.toJson<String>(icon),
    };
  }

  Bank copyWith({
    int? id,
    String? code,
    String? nameEn,
    String? nameFa,
    String? icon,
  }) => Bank(
    id: id ?? this.id,
    code: code ?? this.code,
    nameEn: nameEn ?? this.nameEn,
    nameFa: nameFa ?? this.nameFa,
    icon: icon ?? this.icon,
  );
  Bank copyWithCompanion(BanksCompanion data) {
    return Bank(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bank(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameFa: $nameFa, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, nameEn, nameFa, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bank &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameEn == this.nameEn &&
          other.nameFa == this.nameFa &&
          other.icon == this.icon);
}

class BanksCompanion extends UpdateCompanion<Bank> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameEn;
  final Value<String> nameFa;
  final Value<String> icon;
  const BanksCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.icon = const Value.absent(),
  });
  BanksCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameEn,
    required String nameFa,
    this.icon = const Value.absent(),
  }) : code = Value(code),
       nameEn = Value(nameEn),
       nameFa = Value(nameFa);
  static Insertable<Bank> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameEn,
    Expression<String>? nameFa,
    Expression<String>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameEn != null) 'name_en': nameEn,
      if (nameFa != null) 'name_fa': nameFa,
      if (icon != null) 'icon': icon,
    });
  }

  BanksCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameEn,
    Value<String>? nameFa,
    Value<String>? icon,
  }) {
    return BanksCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameFa: nameFa ?? this.nameFa,
      icon: icon ?? this.icon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BanksCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameFa: $nameFa, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<int> bankId = GeneratedColumn<int>(
    'bank_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (id)',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountKind>($AccountsTable.$converterkind);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<int> openingBalance = GeneratedColumn<int>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
    'sort',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _balanceSetMeta = const VerificationMeta(
    'balanceSet',
  );
  @override
  late final GeneratedColumn<int> balanceSet = GeneratedColumn<int>(
    'balance_set',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceSetAtMeta = const VerificationMeta(
    'balanceSetAt',
  );
  @override
  late final GeneratedColumn<DateTime> balanceSetAt = GeneratedColumn<DateTime>(
    'balance_set_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    bankId,
    number,
    kind,
    icon,
    color,
    openingBalance,
    archived,
    sort,
    balanceSet,
    balanceSetAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bank_id')) {
      context.handle(
        _bankIdMeta,
        bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta),
      );
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('sort')) {
      context.handle(
        _sortMeta,
        sort.isAcceptableOrUnknown(data['sort']!, _sortMeta),
      );
    }
    if (data.containsKey('balance_set')) {
      context.handle(
        _balanceSetMeta,
        balanceSet.isAcceptableOrUnknown(data['balance_set']!, _balanceSetMeta),
      );
    }
    if (data.containsKey('balance_set_at')) {
      context.handle(
        _balanceSetAtMeta,
        balanceSetAt.isAcceptableOrUnknown(
          data['balance_set_at']!,
          _balanceSetAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bank_id'],
      ),
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      ),
      kind: $AccountsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      sort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort'],
      )!,
      balanceSet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_set'],
      ),
      balanceSetAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}balance_set_at'],
      ),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountKind, String, String> $converterkind =
      const EnumNameConverter<AccountKind>(AccountKind.values);
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final int? bankId;

  /// Account/card number exactly as it appears in SMS.
  final String? number;
  final AccountKind kind;
  final String icon;
  final int color;
  final int openingBalance;
  final bool archived;
  final int sort;

  /// Balance the user typed in, valid as of [balanceSetAt]. Null = automatic.
  final int? balanceSet;
  final DateTime? balanceSetAt;
  const Account({
    required this.id,
    required this.name,
    this.bankId,
    this.number,
    required this.kind,
    required this.icon,
    required this.color,
    required this.openingBalance,
    required this.archived,
    required this.sort,
    this.balanceSet,
    this.balanceSetAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bankId != null) {
      map['bank_id'] = Variable<int>(bankId);
    }
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    {
      map['kind'] = Variable<String>($AccountsTable.$converterkind.toSql(kind));
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['opening_balance'] = Variable<int>(openingBalance);
    map['archived'] = Variable<bool>(archived);
    map['sort'] = Variable<int>(sort);
    if (!nullToAbsent || balanceSet != null) {
      map['balance_set'] = Variable<int>(balanceSet);
    }
    if (!nullToAbsent || balanceSetAt != null) {
      map['balance_set_at'] = Variable<DateTime>(balanceSetAt);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      bankId: bankId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankId),
      number: number == null && nullToAbsent
          ? const Value.absent()
          : Value(number),
      kind: Value(kind),
      icon: Value(icon),
      color: Value(color),
      openingBalance: Value(openingBalance),
      archived: Value(archived),
      sort: Value(sort),
      balanceSet: balanceSet == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceSet),
      balanceSetAt: balanceSetAt == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceSetAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bankId: serializer.fromJson<int?>(json['bankId']),
      number: serializer.fromJson<String?>(json['number']),
      kind: $AccountsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      openingBalance: serializer.fromJson<int>(json['openingBalance']),
      archived: serializer.fromJson<bool>(json['archived']),
      sort: serializer.fromJson<int>(json['sort']),
      balanceSet: serializer.fromJson<int?>(json['balanceSet']),
      balanceSetAt: serializer.fromJson<DateTime?>(json['balanceSetAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bankId': serializer.toJson<int?>(bankId),
      'number': serializer.toJson<String?>(number),
      'kind': serializer.toJson<String>(
        $AccountsTable.$converterkind.toJson(kind),
      ),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'openingBalance': serializer.toJson<int>(openingBalance),
      'archived': serializer.toJson<bool>(archived),
      'sort': serializer.toJson<int>(sort),
      'balanceSet': serializer.toJson<int?>(balanceSet),
      'balanceSetAt': serializer.toJson<DateTime?>(balanceSetAt),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    Value<int?> bankId = const Value.absent(),
    Value<String?> number = const Value.absent(),
    AccountKind? kind,
    String? icon,
    int? color,
    int? openingBalance,
    bool? archived,
    int? sort,
    Value<int?> balanceSet = const Value.absent(),
    Value<DateTime?> balanceSetAt = const Value.absent(),
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    bankId: bankId.present ? bankId.value : this.bankId,
    number: number.present ? number.value : this.number,
    kind: kind ?? this.kind,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    openingBalance: openingBalance ?? this.openingBalance,
    archived: archived ?? this.archived,
    sort: sort ?? this.sort,
    balanceSet: balanceSet.present ? balanceSet.value : this.balanceSet,
    balanceSetAt: balanceSetAt.present ? balanceSetAt.value : this.balanceSetAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      number: data.number.present ? data.number.value : this.number,
      kind: data.kind.present ? data.kind.value : this.kind,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      archived: data.archived.present ? data.archived.value : this.archived,
      sort: data.sort.present ? data.sort.value : this.sort,
      balanceSet: data.balanceSet.present
          ? data.balanceSet.value
          : this.balanceSet,
      balanceSetAt: data.balanceSetAt.present
          ? data.balanceSetAt.value
          : this.balanceSetAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bankId: $bankId, ')
          ..write('number: $number, ')
          ..write('kind: $kind, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('archived: $archived, ')
          ..write('sort: $sort, ')
          ..write('balanceSet: $balanceSet, ')
          ..write('balanceSetAt: $balanceSetAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    bankId,
    number,
    kind,
    icon,
    color,
    openingBalance,
    archived,
    sort,
    balanceSet,
    balanceSetAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.bankId == this.bankId &&
          other.number == this.number &&
          other.kind == this.kind &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.openingBalance == this.openingBalance &&
          other.archived == this.archived &&
          other.sort == this.sort &&
          other.balanceSet == this.balanceSet &&
          other.balanceSetAt == this.balanceSetAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> bankId;
  final Value<String?> number;
  final Value<AccountKind> kind;
  final Value<String> icon;
  final Value<int> color;
  final Value<int> openingBalance;
  final Value<bool> archived;
  final Value<int> sort;
  final Value<int?> balanceSet;
  final Value<DateTime?> balanceSetAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bankId = const Value.absent(),
    this.number = const Value.absent(),
    this.kind = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.archived = const Value.absent(),
    this.sort = const Value.absent(),
    this.balanceSet = const Value.absent(),
    this.balanceSetAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.bankId = const Value.absent(),
    this.number = const Value.absent(),
    required AccountKind kind,
    required String icon,
    required int color,
    this.openingBalance = const Value.absent(),
    this.archived = const Value.absent(),
    this.sort = const Value.absent(),
    this.balanceSet = const Value.absent(),
    this.balanceSetAt = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       icon = Value(icon),
       color = Value(color);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? bankId,
    Expression<String>? number,
    Expression<String>? kind,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? openingBalance,
    Expression<bool>? archived,
    Expression<int>? sort,
    Expression<int>? balanceSet,
    Expression<DateTime>? balanceSetAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bankId != null) 'bank_id': bankId,
      if (number != null) 'number': number,
      if (kind != null) 'kind': kind,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (archived != null) 'archived': archived,
      if (sort != null) 'sort': sort,
      if (balanceSet != null) 'balance_set': balanceSet,
      if (balanceSetAt != null) 'balance_set_at': balanceSetAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? bankId,
    Value<String?>? number,
    Value<AccountKind>? kind,
    Value<String>? icon,
    Value<int>? color,
    Value<int>? openingBalance,
    Value<bool>? archived,
    Value<int>? sort,
    Value<int?>? balanceSet,
    Value<DateTime?>? balanceSetAt,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bankId: bankId ?? this.bankId,
      number: number ?? this.number,
      kind: kind ?? this.kind,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      openingBalance: openingBalance ?? this.openingBalance,
      archived: archived ?? this.archived,
      sort: sort ?? this.sort,
      balanceSet: balanceSet ?? this.balanceSet,
      balanceSetAt: balanceSetAt ?? this.balanceSetAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<int>(bankId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AccountsTable.$converterkind.toSql(kind.value),
      );
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<int>(openingBalance.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    if (balanceSet.present) {
      map['balance_set'] = Variable<int>(balanceSet.value);
    }
    if (balanceSetAt.present) {
      map['balance_set_at'] = Variable<DateTime>(balanceSetAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bankId: $bankId, ')
          ..write('number: $number, ')
          ..write('kind: $kind, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('archived: $archived, ')
          ..write('sort: $sort, ')
          ..write('balanceSet: $balanceSet, ')
          ..write('balanceSetAt: $balanceSetAt')
          ..write(')'))
        .toString();
  }
}

class $SmsSendersTable extends SmsSenders
    with TableInfo<$SmsSendersTable, SmsSender> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsSendersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<int> bankId = GeneratedColumn<int>(
    'bank_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (id)',
    ),
  );
  static const VerificationMeta _ignoredMeta = const VerificationMeta(
    'ignored',
  );
  @override
  late final GeneratedColumn<bool> ignored = GeneratedColumn<bool>(
    'ignored',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ignored" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, address, bankId, ignored];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_senders';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsSender> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('bank_id')) {
      context.handle(
        _bankIdMeta,
        bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta),
      );
    }
    if (data.containsKey('ignored')) {
      context.handle(
        _ignoredMeta,
        ignored.isAcceptableOrUnknown(data['ignored']!, _ignoredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsSender map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsSender(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      bankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bank_id'],
      ),
      ignored: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ignored'],
      )!,
    );
  }

  @override
  $SmsSendersTable createAlias(String alias) {
    return $SmsSendersTable(attachedDatabase, alias);
  }
}

class SmsSender extends DataClass implements Insertable<SmsSender> {
  final int id;
  final String address;
  final int? bankId;
  final bool ignored;
  const SmsSender({
    required this.id,
    required this.address,
    this.bankId,
    required this.ignored,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || bankId != null) {
      map['bank_id'] = Variable<int>(bankId);
    }
    map['ignored'] = Variable<bool>(ignored);
    return map;
  }

  SmsSendersCompanion toCompanion(bool nullToAbsent) {
    return SmsSendersCompanion(
      id: Value(id),
      address: Value(address),
      bankId: bankId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankId),
      ignored: Value(ignored),
    );
  }

  factory SmsSender.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsSender(
      id: serializer.fromJson<int>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      bankId: serializer.fromJson<int?>(json['bankId']),
      ignored: serializer.fromJson<bool>(json['ignored']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'address': serializer.toJson<String>(address),
      'bankId': serializer.toJson<int?>(bankId),
      'ignored': serializer.toJson<bool>(ignored),
    };
  }

  SmsSender copyWith({
    int? id,
    String? address,
    Value<int?> bankId = const Value.absent(),
    bool? ignored,
  }) => SmsSender(
    id: id ?? this.id,
    address: address ?? this.address,
    bankId: bankId.present ? bankId.value : this.bankId,
    ignored: ignored ?? this.ignored,
  );
  SmsSender copyWithCompanion(SmsSendersCompanion data) {
    return SmsSender(
      id: data.id.present ? data.id.value : this.id,
      address: data.address.present ? data.address.value : this.address,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      ignored: data.ignored.present ? data.ignored.value : this.ignored,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsSender(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('bankId: $bankId, ')
          ..write('ignored: $ignored')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, address, bankId, ignored);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsSender &&
          other.id == this.id &&
          other.address == this.address &&
          other.bankId == this.bankId &&
          other.ignored == this.ignored);
}

class SmsSendersCompanion extends UpdateCompanion<SmsSender> {
  final Value<int> id;
  final Value<String> address;
  final Value<int?> bankId;
  final Value<bool> ignored;
  const SmsSendersCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.bankId = const Value.absent(),
    this.ignored = const Value.absent(),
  });
  SmsSendersCompanion.insert({
    this.id = const Value.absent(),
    required String address,
    this.bankId = const Value.absent(),
    this.ignored = const Value.absent(),
  }) : address = Value(address);
  static Insertable<SmsSender> custom({
    Expression<int>? id,
    Expression<String>? address,
    Expression<int>? bankId,
    Expression<bool>? ignored,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (bankId != null) 'bank_id': bankId,
      if (ignored != null) 'ignored': ignored,
    });
  }

  SmsSendersCompanion copyWith({
    Value<int>? id,
    Value<String>? address,
    Value<int?>? bankId,
    Value<bool>? ignored,
  }) {
    return SmsSendersCompanion(
      id: id ?? this.id,
      address: address ?? this.address,
      bankId: bankId ?? this.bankId,
      ignored: ignored ?? this.ignored,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<int>(bankId.value);
    }
    if (ignored.present) {
      map['ignored'] = Variable<bool>(ignored.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsSendersCompanion(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('bankId: $bankId, ')
          ..write('ignored: $ignored')
          ..write(')'))
        .toString();
  }
}

class $SmsTemplatesTable extends SmsTemplates
    with TableInfo<$SmsTemplatesTable, SmsTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<int> bankId = GeneratedColumn<int>(
    'bank_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (id)',
    ),
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sampleMeta = const VerificationMeta('sample');
  @override
  late final GeneratedColumn<String> sample = GeneratedColumn<String>(
    'sample',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    bankId,
    sender,
    pattern,
    sample,
    builtin,
    verified,
    enabled,
    priority,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsTemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('bank_id')) {
      context.handle(
        _bankIdMeta,
        bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta),
      );
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('sample')) {
      context.handle(
        _sampleMeta,
        sample.isAcceptableOrUnknown(data['sample']!, _sampleMeta),
      );
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsTemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      bankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bank_id'],
      ),
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      ),
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      sample: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sample'],
      ),
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
    );
  }

  @override
  $SmsTemplatesTable createAlias(String alias) {
    return $SmsTemplatesTable(attachedDatabase, alias);
  }
}

class SmsTemplateRow extends DataClass implements Insertable<SmsTemplateRow> {
  final int id;

  /// Stable id, e.g. `resalat.v1` for built-ins.
  final String code;
  final int? bankId;
  final String? sender;
  final String pattern;
  final String? sample;
  final bool builtin;
  final bool verified;
  final bool enabled;
  final int priority;
  const SmsTemplateRow({
    required this.id,
    required this.code,
    this.bankId,
    this.sender,
    required this.pattern,
    this.sample,
    required this.builtin,
    required this.verified,
    required this.enabled,
    required this.priority,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || bankId != null) {
      map['bank_id'] = Variable<int>(bankId);
    }
    if (!nullToAbsent || sender != null) {
      map['sender'] = Variable<String>(sender);
    }
    map['pattern'] = Variable<String>(pattern);
    if (!nullToAbsent || sample != null) {
      map['sample'] = Variable<String>(sample);
    }
    map['builtin'] = Variable<bool>(builtin);
    map['verified'] = Variable<bool>(verified);
    map['enabled'] = Variable<bool>(enabled);
    map['priority'] = Variable<int>(priority);
    return map;
  }

  SmsTemplatesCompanion toCompanion(bool nullToAbsent) {
    return SmsTemplatesCompanion(
      id: Value(id),
      code: Value(code),
      bankId: bankId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankId),
      sender: sender == null && nullToAbsent
          ? const Value.absent()
          : Value(sender),
      pattern: Value(pattern),
      sample: sample == null && nullToAbsent
          ? const Value.absent()
          : Value(sample),
      builtin: Value(builtin),
      verified: Value(verified),
      enabled: Value(enabled),
      priority: Value(priority),
    );
  }

  factory SmsTemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsTemplateRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      bankId: serializer.fromJson<int?>(json['bankId']),
      sender: serializer.fromJson<String?>(json['sender']),
      pattern: serializer.fromJson<String>(json['pattern']),
      sample: serializer.fromJson<String?>(json['sample']),
      builtin: serializer.fromJson<bool>(json['builtin']),
      verified: serializer.fromJson<bool>(json['verified']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      priority: serializer.fromJson<int>(json['priority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'bankId': serializer.toJson<int?>(bankId),
      'sender': serializer.toJson<String?>(sender),
      'pattern': serializer.toJson<String>(pattern),
      'sample': serializer.toJson<String?>(sample),
      'builtin': serializer.toJson<bool>(builtin),
      'verified': serializer.toJson<bool>(verified),
      'enabled': serializer.toJson<bool>(enabled),
      'priority': serializer.toJson<int>(priority),
    };
  }

  SmsTemplateRow copyWith({
    int? id,
    String? code,
    Value<int?> bankId = const Value.absent(),
    Value<String?> sender = const Value.absent(),
    String? pattern,
    Value<String?> sample = const Value.absent(),
    bool? builtin,
    bool? verified,
    bool? enabled,
    int? priority,
  }) => SmsTemplateRow(
    id: id ?? this.id,
    code: code ?? this.code,
    bankId: bankId.present ? bankId.value : this.bankId,
    sender: sender.present ? sender.value : this.sender,
    pattern: pattern ?? this.pattern,
    sample: sample.present ? sample.value : this.sample,
    builtin: builtin ?? this.builtin,
    verified: verified ?? this.verified,
    enabled: enabled ?? this.enabled,
    priority: priority ?? this.priority,
  );
  SmsTemplateRow copyWithCompanion(SmsTemplatesCompanion data) {
    return SmsTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      sender: data.sender.present ? data.sender.value : this.sender,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      sample: data.sample.present ? data.sample.value : this.sample,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
      verified: data.verified.present ? data.verified.value : this.verified,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      priority: data.priority.present ? data.priority.value : this.priority,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsTemplateRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('bankId: $bankId, ')
          ..write('sender: $sender, ')
          ..write('pattern: $pattern, ')
          ..write('sample: $sample, ')
          ..write('builtin: $builtin, ')
          ..write('verified: $verified, ')
          ..write('enabled: $enabled, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    bankId,
    sender,
    pattern,
    sample,
    builtin,
    verified,
    enabled,
    priority,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsTemplateRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.bankId == this.bankId &&
          other.sender == this.sender &&
          other.pattern == this.pattern &&
          other.sample == this.sample &&
          other.builtin == this.builtin &&
          other.verified == this.verified &&
          other.enabled == this.enabled &&
          other.priority == this.priority);
}

class SmsTemplatesCompanion extends UpdateCompanion<SmsTemplateRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<int?> bankId;
  final Value<String?> sender;
  final Value<String> pattern;
  final Value<String?> sample;
  final Value<bool> builtin;
  final Value<bool> verified;
  final Value<bool> enabled;
  final Value<int> priority;
  const SmsTemplatesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.bankId = const Value.absent(),
    this.sender = const Value.absent(),
    this.pattern = const Value.absent(),
    this.sample = const Value.absent(),
    this.builtin = const Value.absent(),
    this.verified = const Value.absent(),
    this.enabled = const Value.absent(),
    this.priority = const Value.absent(),
  });
  SmsTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.bankId = const Value.absent(),
    this.sender = const Value.absent(),
    required String pattern,
    this.sample = const Value.absent(),
    this.builtin = const Value.absent(),
    this.verified = const Value.absent(),
    this.enabled = const Value.absent(),
    this.priority = const Value.absent(),
  }) : code = Value(code),
       pattern = Value(pattern);
  static Insertable<SmsTemplateRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<int>? bankId,
    Expression<String>? sender,
    Expression<String>? pattern,
    Expression<String>? sample,
    Expression<bool>? builtin,
    Expression<bool>? verified,
    Expression<bool>? enabled,
    Expression<int>? priority,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (bankId != null) 'bank_id': bankId,
      if (sender != null) 'sender': sender,
      if (pattern != null) 'pattern': pattern,
      if (sample != null) 'sample': sample,
      if (builtin != null) 'builtin': builtin,
      if (verified != null) 'verified': verified,
      if (enabled != null) 'enabled': enabled,
      if (priority != null) 'priority': priority,
    });
  }

  SmsTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<int?>? bankId,
    Value<String?>? sender,
    Value<String>? pattern,
    Value<String?>? sample,
    Value<bool>? builtin,
    Value<bool>? verified,
    Value<bool>? enabled,
    Value<int>? priority,
  }) {
    return SmsTemplatesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      bankId: bankId ?? this.bankId,
      sender: sender ?? this.sender,
      pattern: pattern ?? this.pattern,
      sample: sample ?? this.sample,
      builtin: builtin ?? this.builtin,
      verified: verified ?? this.verified,
      enabled: enabled ?? this.enabled,
      priority: priority ?? this.priority,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<int>(bankId.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (sample.present) {
      map['sample'] = Variable<String>(sample.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('bankId: $bankId, ')
          ..write('sender: $sender, ')
          ..write('pattern: $pattern, ')
          ..write('sample: $sample, ')
          ..write('builtin: $builtin, ')
          ..write('verified: $verified, ')
          ..write('enabled: $enabled, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }
}

class $RawSmsTable extends RawSms with TableInfo<$RawSmsTable, RawSmsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawSmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SmsStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SmsStatus>($RawSmsTable.$converterstatus);
  static const VerificationMeta _templateCodeMeta = const VerificationMeta(
    'templateCode',
  );
  @override
  late final GeneratedColumn<String> templateCode = GeneratedColumn<String>(
    'template_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    address,
    body,
    receivedAt,
    hash,
    status,
    templateCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_sms';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawSmsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('template_code')) {
      context.handle(
        _templateCodeMeta,
        templateCode.isAcceptableOrUnknown(
          data['template_code']!,
          _templateCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RawSmsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawSmsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
      status: $RawSmsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      templateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_code'],
      ),
    );
  }

  @override
  $RawSmsTable createAlias(String alias) {
    return $RawSmsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SmsStatus, String, String> $converterstatus =
      const EnumNameConverter<SmsStatus>(SmsStatus.values);
}

class RawSmsRow extends DataClass implements Insertable<RawSmsRow> {
  final int id;
  final String address;
  final String body;
  final DateTime receivedAt;
  final String hash;
  final SmsStatus status;
  final String? templateCode;
  const RawSmsRow({
    required this.id,
    required this.address,
    required this.body,
    required this.receivedAt,
    required this.hash,
    required this.status,
    this.templateCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['address'] = Variable<String>(address);
    map['body'] = Variable<String>(body);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['hash'] = Variable<String>(hash);
    {
      map['status'] = Variable<String>(
        $RawSmsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || templateCode != null) {
      map['template_code'] = Variable<String>(templateCode);
    }
    return map;
  }

  RawSmsCompanion toCompanion(bool nullToAbsent) {
    return RawSmsCompanion(
      id: Value(id),
      address: Value(address),
      body: Value(body),
      receivedAt: Value(receivedAt),
      hash: Value(hash),
      status: Value(status),
      templateCode: templateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(templateCode),
    );
  }

  factory RawSmsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawSmsRow(
      id: serializer.fromJson<int>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      body: serializer.fromJson<String>(json['body']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      hash: serializer.fromJson<String>(json['hash']),
      status: $RawSmsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      templateCode: serializer.fromJson<String?>(json['templateCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'address': serializer.toJson<String>(address),
      'body': serializer.toJson<String>(body),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'hash': serializer.toJson<String>(hash),
      'status': serializer.toJson<String>(
        $RawSmsTable.$converterstatus.toJson(status),
      ),
      'templateCode': serializer.toJson<String?>(templateCode),
    };
  }

  RawSmsRow copyWith({
    int? id,
    String? address,
    String? body,
    DateTime? receivedAt,
    String? hash,
    SmsStatus? status,
    Value<String?> templateCode = const Value.absent(),
  }) => RawSmsRow(
    id: id ?? this.id,
    address: address ?? this.address,
    body: body ?? this.body,
    receivedAt: receivedAt ?? this.receivedAt,
    hash: hash ?? this.hash,
    status: status ?? this.status,
    templateCode: templateCode.present ? templateCode.value : this.templateCode,
  );
  RawSmsRow copyWithCompanion(RawSmsCompanion data) {
    return RawSmsRow(
      id: data.id.present ? data.id.value : this.id,
      address: data.address.present ? data.address.value : this.address,
      body: data.body.present ? data.body.value : this.body,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      hash: data.hash.present ? data.hash.value : this.hash,
      status: data.status.present ? data.status.value : this.status,
      templateCode: data.templateCode.present
          ? data.templateCode.value
          : this.templateCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawSmsRow(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('hash: $hash, ')
          ..write('status: $status, ')
          ..write('templateCode: $templateCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, address, body, receivedAt, hash, status, templateCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawSmsRow &&
          other.id == this.id &&
          other.address == this.address &&
          other.body == this.body &&
          other.receivedAt == this.receivedAt &&
          other.hash == this.hash &&
          other.status == this.status &&
          other.templateCode == this.templateCode);
}

class RawSmsCompanion extends UpdateCompanion<RawSmsRow> {
  final Value<int> id;
  final Value<String> address;
  final Value<String> body;
  final Value<DateTime> receivedAt;
  final Value<String> hash;
  final Value<SmsStatus> status;
  final Value<String?> templateCode;
  const RawSmsCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.body = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.hash = const Value.absent(),
    this.status = const Value.absent(),
    this.templateCode = const Value.absent(),
  });
  RawSmsCompanion.insert({
    this.id = const Value.absent(),
    required String address,
    required String body,
    required DateTime receivedAt,
    required String hash,
    required SmsStatus status,
    this.templateCode = const Value.absent(),
  }) : address = Value(address),
       body = Value(body),
       receivedAt = Value(receivedAt),
       hash = Value(hash),
       status = Value(status);
  static Insertable<RawSmsRow> custom({
    Expression<int>? id,
    Expression<String>? address,
    Expression<String>? body,
    Expression<DateTime>? receivedAt,
    Expression<String>? hash,
    Expression<String>? status,
    Expression<String>? templateCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (body != null) 'body': body,
      if (receivedAt != null) 'received_at': receivedAt,
      if (hash != null) 'hash': hash,
      if (status != null) 'status': status,
      if (templateCode != null) 'template_code': templateCode,
    });
  }

  RawSmsCompanion copyWith({
    Value<int>? id,
    Value<String>? address,
    Value<String>? body,
    Value<DateTime>? receivedAt,
    Value<String>? hash,
    Value<SmsStatus>? status,
    Value<String?>? templateCode,
  }) {
    return RawSmsCompanion(
      id: id ?? this.id,
      address: address ?? this.address,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      hash: hash ?? this.hash,
      status: status ?? this.status,
      templateCode: templateCode ?? this.templateCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $RawSmsTable.$converterstatus.toSql(status.value),
      );
    }
    if (templateCode.present) {
      map['template_code'] = Variable<String>(templateCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawSmsCompanion(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('hash: $hash, ')
          ..write('status: $status, ')
          ..write('templateCode: $templateCode')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategoryKind>($CategoriesTable.$converterkind);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
    'sort',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    kind,
    name,
    nameKey,
    icon,
    color,
    builtin,
    archived,
    sort,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('sort')) {
      context.handle(
        _sortMeta,
        sort.isAcceptableOrUnknown(data['sort']!, _sortMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      kind: $CategoriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      sort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryKind, String, String> $converterkind =
      const EnumNameConverter<CategoryKind>(CategoryKind.values);
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final int? parentId;
  final CategoryKind kind;

  /// User-visible name. Built-ins also carry [nameKey] for translation until renamed.
  final String name;
  final String? nameKey;
  final String icon;
  final int color;
  final bool builtin;
  final bool archived;
  final int sort;
  const Category({
    required this.id,
    this.parentId,
    required this.kind,
    required this.name,
    this.nameKey,
    required this.icon,
    required this.color,
    required this.builtin,
    required this.archived,
    required this.sort,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameKey != null) {
      map['name_key'] = Variable<String>(nameKey);
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['builtin'] = Variable<bool>(builtin);
    map['archived'] = Variable<bool>(archived);
    map['sort'] = Variable<int>(sort);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      kind: Value(kind),
      name: Value(name),
      nameKey: nameKey == null && nullToAbsent
          ? const Value.absent()
          : Value(nameKey),
      icon: Value(icon),
      color: Value(color),
      builtin: Value(builtin),
      archived: Value(archived),
      sort: Value(sort),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      kind: $CategoriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      name: serializer.fromJson<String>(json['name']),
      nameKey: serializer.fromJson<String?>(json['nameKey']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      builtin: serializer.fromJson<bool>(json['builtin']),
      archived: serializer.fromJson<bool>(json['archived']),
      sort: serializer.fromJson<int>(json['sort']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int?>(parentId),
      'kind': serializer.toJson<String>(
        $CategoriesTable.$converterkind.toJson(kind),
      ),
      'name': serializer.toJson<String>(name),
      'nameKey': serializer.toJson<String?>(nameKey),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'builtin': serializer.toJson<bool>(builtin),
      'archived': serializer.toJson<bool>(archived),
      'sort': serializer.toJson<int>(sort),
    };
  }

  Category copyWith({
    int? id,
    Value<int?> parentId = const Value.absent(),
    CategoryKind? kind,
    String? name,
    Value<String?> nameKey = const Value.absent(),
    String? icon,
    int? color,
    bool? builtin,
    bool? archived,
    int? sort,
  }) => Category(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    nameKey: nameKey.present ? nameKey.value : this.nameKey,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    builtin: builtin ?? this.builtin,
    archived: archived ?? this.archived,
    sort: sort ?? this.sort,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
      archived: data.archived.present ? data.archived.value : this.archived,
      sort: data.sort.present ? data.sort.value : this.sort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('builtin: $builtin, ')
          ..write('archived: $archived, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    kind,
    name,
    nameKey,
    icon,
    color,
    builtin,
    archived,
    sort,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.nameKey == this.nameKey &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.builtin == this.builtin &&
          other.archived == this.archived &&
          other.sort == this.sort);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<int?> parentId;
  final Value<CategoryKind> kind;
  final Value<String> name;
  final Value<String?> nameKey;
  final Value<String> icon;
  final Value<int> color;
  final Value<bool> builtin;
  final Value<bool> archived;
  final Value<int> sort;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.builtin = const Value.absent(),
    this.archived = const Value.absent(),
    this.sort = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    required CategoryKind kind,
    required String name,
    this.nameKey = const Value.absent(),
    required String icon,
    required int color,
    this.builtin = const Value.absent(),
    this.archived = const Value.absent(),
    this.sort = const Value.absent(),
  }) : kind = Value(kind),
       name = Value(name),
       icon = Value(icon),
       color = Value(color);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? nameKey,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<bool>? builtin,
    Expression<bool>? archived,
    Expression<int>? sort,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (nameKey != null) 'name_key': nameKey,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (builtin != null) 'builtin': builtin,
      if (archived != null) 'archived': archived,
      if (sort != null) 'sort': sort,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<int?>? parentId,
    Value<CategoryKind>? kind,
    Value<String>? name,
    Value<String?>? nameKey,
    Value<String>? icon,
    Value<int>? color,
    Value<bool>? builtin,
    Value<bool>? archived,
    Value<int>? sort,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      nameKey: nameKey ?? this.nameKey,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      builtin: builtin ?? this.builtin,
      archived: archived ?? this.archived,
      sort: sort ?? this.sort,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('builtin: $builtin, ')
          ..write('archived: $archived, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameKey,
    icon,
    color,
    builtin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final String? nameKey;
  final String icon;
  final int color;
  final bool builtin;
  const Tag({
    required this.id,
    required this.name,
    this.nameKey,
    required this.icon,
    required this.color,
    required this.builtin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameKey != null) {
      map['name_key'] = Variable<String>(nameKey);
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['builtin'] = Variable<bool>(builtin);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      nameKey: nameKey == null && nullToAbsent
          ? const Value.absent()
          : Value(nameKey),
      icon: Value(icon),
      color: Value(color),
      builtin: Value(builtin),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameKey: serializer.fromJson<String?>(json['nameKey']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      builtin: serializer.fromJson<bool>(json['builtin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameKey': serializer.toJson<String?>(nameKey),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'builtin': serializer.toJson<bool>(builtin),
    };
  }

  Tag copyWith({
    int? id,
    String? name,
    Value<String?> nameKey = const Value.absent(),
    String? icon,
    int? color,
    bool? builtin,
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    nameKey: nameKey.present ? nameKey.value : this.nameKey,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    builtin: builtin ?? this.builtin,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('builtin: $builtin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nameKey, icon, color, builtin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameKey == this.nameKey &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.builtin == this.builtin);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nameKey;
  final Value<String> icon;
  final Value<int> color;
  final Value<bool> builtin;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.builtin = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameKey = const Value.absent(),
    required String icon,
    required int color,
    this.builtin = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       color = Value(color);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameKey,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<bool>? builtin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameKey != null) 'name_key': nameKey,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (builtin != null) 'builtin': builtin,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nameKey,
    Value<String>? icon,
    Value<int>? color,
    Value<bool>? builtin,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameKey: nameKey ?? this.nameKey,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      builtin: builtin ?? this.builtin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('builtin: $builtin')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jalaliYmMeta = const VerificationMeta(
    'jalaliYm',
  );
  @override
  late final GeneratedColumn<int> jalaliYm = GeneratedColumn<int>(
    'jalali_ym',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceAfterMeta = const VerificationMeta(
    'balanceAfter',
  );
  @override
  late final GeneratedColumn<int> balanceAfter = GeneratedColumn<int>(
    'balance_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxKind>($TransactionsTable.$converterkind);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _markedMeta = const VerificationMeta('marked');
  @override
  late final GeneratedColumn<bool> marked = GeneratedColumn<bool>(
    'marked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("marked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _excludedMeta = const VerificationMeta(
    'excluded',
  );
  @override
  late final GeneratedColumn<bool> excluded = GeneratedColumn<bool>(
    'excluded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("excluded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _needsReviewMeta = const VerificationMeta(
    'needsReview',
  );
  @override
  late final GeneratedColumn<bool> needsReview = GeneratedColumn<bool>(
    'needs_review',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_review" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxSource>($TransactionsTable.$convertersource);
  static const VerificationMeta _rawSmsIdMeta = const VerificationMeta(
    'rawSmsId',
  );
  @override
  late final GeneratedColumn<int> rawSmsId = GeneratedColumn<int>(
    'raw_sms_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES raw_sms (id)',
    ),
  );
  static const VerificationMeta _transferGroupIdMeta = const VerificationMeta(
    'transferGroupId',
  );
  @override
  late final GeneratedColumn<int> transferGroupId = GeneratedColumn<int>(
    'transfer_group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringIdMeta = const VerificationMeta(
    'recurringId',
  );
  @override
  late final GeneratedColumn<int> recurringId = GeneratedColumn<int>(
    'recurring_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceGapMeta = const VerificationMeta(
    'balanceGap',
  );
  @override
  late final GeneratedColumn<int> balanceGap = GeneratedColumn<int>(
    'balance_gap',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    amount,
    occurredAt,
    jalaliYm,
    balanceAfter,
    kind,
    categoryId,
    note,
    marked,
    excluded,
    needsReview,
    source,
    rawSmsId,
    transferGroupId,
    recurringId,
    balanceGap,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('jalali_ym')) {
      context.handle(
        _jalaliYmMeta,
        jalaliYm.isAcceptableOrUnknown(data['jalali_ym']!, _jalaliYmMeta),
      );
    } else if (isInserting) {
      context.missing(_jalaliYmMeta);
    }
    if (data.containsKey('balance_after')) {
      context.handle(
        _balanceAfterMeta,
        balanceAfter.isAcceptableOrUnknown(
          data['balance_after']!,
          _balanceAfterMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('marked')) {
      context.handle(
        _markedMeta,
        marked.isAcceptableOrUnknown(data['marked']!, _markedMeta),
      );
    }
    if (data.containsKey('excluded')) {
      context.handle(
        _excludedMeta,
        excluded.isAcceptableOrUnknown(data['excluded']!, _excludedMeta),
      );
    }
    if (data.containsKey('needs_review')) {
      context.handle(
        _needsReviewMeta,
        needsReview.isAcceptableOrUnknown(
          data['needs_review']!,
          _needsReviewMeta,
        ),
      );
    }
    if (data.containsKey('raw_sms_id')) {
      context.handle(
        _rawSmsIdMeta,
        rawSmsId.isAcceptableOrUnknown(data['raw_sms_id']!, _rawSmsIdMeta),
      );
    }
    if (data.containsKey('transfer_group_id')) {
      context.handle(
        _transferGroupIdMeta,
        transferGroupId.isAcceptableOrUnknown(
          data['transfer_group_id']!,
          _transferGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('recurring_id')) {
      context.handle(
        _recurringIdMeta,
        recurringId.isAcceptableOrUnknown(
          data['recurring_id']!,
          _recurringIdMeta,
        ),
      );
    }
    if (data.containsKey('balance_gap')) {
      context.handle(
        _balanceGapMeta,
        balanceGap.isAcceptableOrUnknown(data['balance_gap']!, _balanceGapMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      jalaliYm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jalali_ym'],
      )!,
      balanceAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_after'],
      ),
      kind: $TransactionsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      marked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}marked'],
      )!,
      excluded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}excluded'],
      )!,
      needsReview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_review'],
      )!,
      source: $TransactionsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      rawSmsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}raw_sms_id'],
      ),
      transferGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transfer_group_id'],
      ),
      recurringId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurring_id'],
      ),
      balanceGap: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_gap'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxKind, String, String> $converterkind =
      const EnumNameConverter<TxKind>(TxKind.values);
  static JsonTypeConverter2<TxSource, String, String> $convertersource =
      const EnumNameConverter<TxSource>(TxSource.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int accountId;

  /// Signed Rial. Negative = money out.
  final int amount;
  final DateTime occurredAt;

  /// Jalali year*100+month, denormalized for monthly reports.
  final int jalaliYm;
  final int? balanceAfter;
  final TxKind kind;
  final int? categoryId;
  final String note;
  final bool marked;
  final bool excluded;
  final bool needsReview;
  final TxSource source;
  final int? rawSmsId;
  final int? transferGroupId;
  final int? recurringId;

  /// Rial the balance moved that no SMS explains; 0 = consistent, null = unknown.
  final int? balanceGap;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Transaction({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.occurredAt,
    required this.jalaliYm,
    this.balanceAfter,
    required this.kind,
    this.categoryId,
    required this.note,
    required this.marked,
    required this.excluded,
    required this.needsReview,
    required this.source,
    this.rawSmsId,
    this.transferGroupId,
    this.recurringId,
    this.balanceGap,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['amount'] = Variable<int>(amount);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['jalali_ym'] = Variable<int>(jalaliYm);
    if (!nullToAbsent || balanceAfter != null) {
      map['balance_after'] = Variable<int>(balanceAfter);
    }
    {
      map['kind'] = Variable<String>(
        $TransactionsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['note'] = Variable<String>(note);
    map['marked'] = Variable<bool>(marked);
    map['excluded'] = Variable<bool>(excluded);
    map['needs_review'] = Variable<bool>(needsReview);
    {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || rawSmsId != null) {
      map['raw_sms_id'] = Variable<int>(rawSmsId);
    }
    if (!nullToAbsent || transferGroupId != null) {
      map['transfer_group_id'] = Variable<int>(transferGroupId);
    }
    if (!nullToAbsent || recurringId != null) {
      map['recurring_id'] = Variable<int>(recurringId);
    }
    if (!nullToAbsent || balanceGap != null) {
      map['balance_gap'] = Variable<int>(balanceGap);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      amount: Value(amount),
      occurredAt: Value(occurredAt),
      jalaliYm: Value(jalaliYm),
      balanceAfter: balanceAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceAfter),
      kind: Value(kind),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      note: Value(note),
      marked: Value(marked),
      excluded: Value(excluded),
      needsReview: Value(needsReview),
      source: Value(source),
      rawSmsId: rawSmsId == null && nullToAbsent
          ? const Value.absent()
          : Value(rawSmsId),
      transferGroupId: transferGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferGroupId),
      recurringId: recurringId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringId),
      balanceGap: balanceGap == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceGap),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      amount: serializer.fromJson<int>(json['amount']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      jalaliYm: serializer.fromJson<int>(json['jalaliYm']),
      balanceAfter: serializer.fromJson<int?>(json['balanceAfter']),
      kind: $TransactionsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      note: serializer.fromJson<String>(json['note']),
      marked: serializer.fromJson<bool>(json['marked']),
      excluded: serializer.fromJson<bool>(json['excluded']),
      needsReview: serializer.fromJson<bool>(json['needsReview']),
      source: $TransactionsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      rawSmsId: serializer.fromJson<int?>(json['rawSmsId']),
      transferGroupId: serializer.fromJson<int?>(json['transferGroupId']),
      recurringId: serializer.fromJson<int?>(json['recurringId']),
      balanceGap: serializer.fromJson<int?>(json['balanceGap']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'amount': serializer.toJson<int>(amount),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'jalaliYm': serializer.toJson<int>(jalaliYm),
      'balanceAfter': serializer.toJson<int?>(balanceAfter),
      'kind': serializer.toJson<String>(
        $TransactionsTable.$converterkind.toJson(kind),
      ),
      'categoryId': serializer.toJson<int?>(categoryId),
      'note': serializer.toJson<String>(note),
      'marked': serializer.toJson<bool>(marked),
      'excluded': serializer.toJson<bool>(excluded),
      'needsReview': serializer.toJson<bool>(needsReview),
      'source': serializer.toJson<String>(
        $TransactionsTable.$convertersource.toJson(source),
      ),
      'rawSmsId': serializer.toJson<int?>(rawSmsId),
      'transferGroupId': serializer.toJson<int?>(transferGroupId),
      'recurringId': serializer.toJson<int?>(recurringId),
      'balanceGap': serializer.toJson<int?>(balanceGap),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Transaction copyWith({
    int? id,
    int? accountId,
    int? amount,
    DateTime? occurredAt,
    int? jalaliYm,
    Value<int?> balanceAfter = const Value.absent(),
    TxKind? kind,
    Value<int?> categoryId = const Value.absent(),
    String? note,
    bool? marked,
    bool? excluded,
    bool? needsReview,
    TxSource? source,
    Value<int?> rawSmsId = const Value.absent(),
    Value<int?> transferGroupId = const Value.absent(),
    Value<int?> recurringId = const Value.absent(),
    Value<int?> balanceGap = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    amount: amount ?? this.amount,
    occurredAt: occurredAt ?? this.occurredAt,
    jalaliYm: jalaliYm ?? this.jalaliYm,
    balanceAfter: balanceAfter.present ? balanceAfter.value : this.balanceAfter,
    kind: kind ?? this.kind,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note ?? this.note,
    marked: marked ?? this.marked,
    excluded: excluded ?? this.excluded,
    needsReview: needsReview ?? this.needsReview,
    source: source ?? this.source,
    rawSmsId: rawSmsId.present ? rawSmsId.value : this.rawSmsId,
    transferGroupId: transferGroupId.present
        ? transferGroupId.value
        : this.transferGroupId,
    recurringId: recurringId.present ? recurringId.value : this.recurringId,
    balanceGap: balanceGap.present ? balanceGap.value : this.balanceGap,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      jalaliYm: data.jalaliYm.present ? data.jalaliYm.value : this.jalaliYm,
      balanceAfter: data.balanceAfter.present
          ? data.balanceAfter.value
          : this.balanceAfter,
      kind: data.kind.present ? data.kind.value : this.kind,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      marked: data.marked.present ? data.marked.value : this.marked,
      excluded: data.excluded.present ? data.excluded.value : this.excluded,
      needsReview: data.needsReview.present
          ? data.needsReview.value
          : this.needsReview,
      source: data.source.present ? data.source.value : this.source,
      rawSmsId: data.rawSmsId.present ? data.rawSmsId.value : this.rawSmsId,
      transferGroupId: data.transferGroupId.present
          ? data.transferGroupId.value
          : this.transferGroupId,
      recurringId: data.recurringId.present
          ? data.recurringId.value
          : this.recurringId,
      balanceGap: data.balanceGap.present
          ? data.balanceGap.value
          : this.balanceGap,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('jalaliYm: $jalaliYm, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('kind: $kind, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('marked: $marked, ')
          ..write('excluded: $excluded, ')
          ..write('needsReview: $needsReview, ')
          ..write('source: $source, ')
          ..write('rawSmsId: $rawSmsId, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('recurringId: $recurringId, ')
          ..write('balanceGap: $balanceGap, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    amount,
    occurredAt,
    jalaliYm,
    balanceAfter,
    kind,
    categoryId,
    note,
    marked,
    excluded,
    needsReview,
    source,
    rawSmsId,
    transferGroupId,
    recurringId,
    balanceGap,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.amount == this.amount &&
          other.occurredAt == this.occurredAt &&
          other.jalaliYm == this.jalaliYm &&
          other.balanceAfter == this.balanceAfter &&
          other.kind == this.kind &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.marked == this.marked &&
          other.excluded == this.excluded &&
          other.needsReview == this.needsReview &&
          other.source == this.source &&
          other.rawSmsId == this.rawSmsId &&
          other.transferGroupId == this.transferGroupId &&
          other.recurringId == this.recurringId &&
          other.balanceGap == this.balanceGap &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int> amount;
  final Value<DateTime> occurredAt;
  final Value<int> jalaliYm;
  final Value<int?> balanceAfter;
  final Value<TxKind> kind;
  final Value<int?> categoryId;
  final Value<String> note;
  final Value<bool> marked;
  final Value<bool> excluded;
  final Value<bool> needsReview;
  final Value<TxSource> source;
  final Value<int?> rawSmsId;
  final Value<int?> transferGroupId;
  final Value<int?> recurringId;
  final Value<int?> balanceGap;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.jalaliYm = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.kind = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.marked = const Value.absent(),
    this.excluded = const Value.absent(),
    this.needsReview = const Value.absent(),
    this.source = const Value.absent(),
    this.rawSmsId = const Value.absent(),
    this.transferGroupId = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.balanceGap = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required int amount,
    required DateTime occurredAt,
    required int jalaliYm,
    this.balanceAfter = const Value.absent(),
    required TxKind kind,
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.marked = const Value.absent(),
    this.excluded = const Value.absent(),
    this.needsReview = const Value.absent(),
    required TxSource source,
    this.rawSmsId = const Value.absent(),
    this.transferGroupId = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.balanceGap = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       amount = Value(amount),
       occurredAt = Value(occurredAt),
       jalaliYm = Value(jalaliYm),
       kind = Value(kind),
       source = Value(source);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? amount,
    Expression<DateTime>? occurredAt,
    Expression<int>? jalaliYm,
    Expression<int>? balanceAfter,
    Expression<String>? kind,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<bool>? marked,
    Expression<bool>? excluded,
    Expression<bool>? needsReview,
    Expression<String>? source,
    Expression<int>? rawSmsId,
    Expression<int>? transferGroupId,
    Expression<int>? recurringId,
    Expression<int>? balanceGap,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (amount != null) 'amount': amount,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (jalaliYm != null) 'jalali_ym': jalaliYm,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (kind != null) 'kind': kind,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (marked != null) 'marked': marked,
      if (excluded != null) 'excluded': excluded,
      if (needsReview != null) 'needs_review': needsReview,
      if (source != null) 'source': source,
      if (rawSmsId != null) 'raw_sms_id': rawSmsId,
      if (transferGroupId != null) 'transfer_group_id': transferGroupId,
      if (recurringId != null) 'recurring_id': recurringId,
      if (balanceGap != null) 'balance_gap': balanceGap,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int>? amount,
    Value<DateTime>? occurredAt,
    Value<int>? jalaliYm,
    Value<int?>? balanceAfter,
    Value<TxKind>? kind,
    Value<int?>? categoryId,
    Value<String>? note,
    Value<bool>? marked,
    Value<bool>? excluded,
    Value<bool>? needsReview,
    Value<TxSource>? source,
    Value<int?>? rawSmsId,
    Value<int?>? transferGroupId,
    Value<int?>? recurringId,
    Value<int?>? balanceGap,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      amount: amount ?? this.amount,
      occurredAt: occurredAt ?? this.occurredAt,
      jalaliYm: jalaliYm ?? this.jalaliYm,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      kind: kind ?? this.kind,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      marked: marked ?? this.marked,
      excluded: excluded ?? this.excluded,
      needsReview: needsReview ?? this.needsReview,
      source: source ?? this.source,
      rawSmsId: rawSmsId ?? this.rawSmsId,
      transferGroupId: transferGroupId ?? this.transferGroupId,
      recurringId: recurringId ?? this.recurringId,
      balanceGap: balanceGap ?? this.balanceGap,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (jalaliYm.present) {
      map['jalali_ym'] = Variable<int>(jalaliYm.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<int>(balanceAfter.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TransactionsTable.$converterkind.toSql(kind.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (marked.present) {
      map['marked'] = Variable<bool>(marked.value);
    }
    if (excluded.present) {
      map['excluded'] = Variable<bool>(excluded.value);
    }
    if (needsReview.present) {
      map['needs_review'] = Variable<bool>(needsReview.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source.value),
      );
    }
    if (rawSmsId.present) {
      map['raw_sms_id'] = Variable<int>(rawSmsId.value);
    }
    if (transferGroupId.present) {
      map['transfer_group_id'] = Variable<int>(transferGroupId.value);
    }
    if (recurringId.present) {
      map['recurring_id'] = Variable<int>(recurringId.value);
    }
    if (balanceGap.present) {
      map['balance_gap'] = Variable<int>(balanceGap.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('jalaliYm: $jalaliYm, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('kind: $kind, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('marked: $marked, ')
          ..write('excluded: $excluded, ')
          ..write('needsReview: $needsReview, ')
          ..write('source: $source, ')
          ..write('rawSmsId: $rawSmsId, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('recurringId: $recurringId, ')
          ..write('balanceGap: $balanceGap, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionTagsTable extends TransactionTags
    with TableInfo<$TransactionTagsTable, TransactionTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [transactionId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transactionId, tagId};
  @override
  TransactionTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTag(
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $TransactionTagsTable createAlias(String alias) {
    return $TransactionTagsTable(attachedDatabase, alias);
  }
}

class TransactionTag extends DataClass implements Insertable<TransactionTag> {
  final int transactionId;
  final int tagId;
  const TransactionTag({required this.transactionId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_id'] = Variable<int>(transactionId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  TransactionTagsCompanion toCompanion(bool nullToAbsent) {
    return TransactionTagsCompanion(
      transactionId: Value(transactionId),
      tagId: Value(tagId),
    );
  }

  factory TransactionTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTag(
      transactionId: serializer.fromJson<int>(json['transactionId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionId': serializer.toJson<int>(transactionId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  TransactionTag copyWith({int? transactionId, int? tagId}) => TransactionTag(
    transactionId: transactionId ?? this.transactionId,
    tagId: tagId ?? this.tagId,
  );
  TransactionTag copyWithCompanion(TransactionTagsCompanion data) {
    return TransactionTag(
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTag(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transactionId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTag &&
          other.transactionId == this.transactionId &&
          other.tagId == this.tagId);
}

class TransactionTagsCompanion extends UpdateCompanion<TransactionTag> {
  final Value<int> transactionId;
  final Value<int> tagId;
  final Value<int> rowid;
  const TransactionTagsCompanion({
    this.transactionId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionTagsCompanion.insert({
    required int transactionId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : transactionId = Value(transactionId),
       tagId = Value(tagId);
  static Insertable<TransactionTag> custom({
    Expression<int>? transactionId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (transactionId != null) 'transaction_id': transactionId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionTagsCompanion copyWith({
    Value<int>? transactionId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return TransactionTagsCompanion(
      transactionId: transactionId ?? this.transactionId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTagsCompanion(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeopleTable extends People with TableInfo<$PeopleTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeopleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, icon, color, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'people';
  @override
  VerificationContext validateIntegrity(
    Insertable<Person> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String name;
  final String? phone;
  final String icon;
  final int color;
  final String note;
  const Person({
    required this.id,
    required this.name,
    this.phone,
    required this.icon,
    required this.color,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['note'] = Variable<String>(note);
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      icon: Value(icon),
      color: Value(color),
      note: Value(note),
    );
  }

  factory Person.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'note': serializer.toJson<String>(note),
    };
  }

  Person copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    String? icon,
    int? color,
    String? note,
  }) => Person(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    note: note ?? this.note,
  );
  Person copyWithCompanion(PeopleCompanion data) {
    return Person(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, icon, color, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.note == this.note);
}

class PeopleCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> icon;
  final Value<int> color;
  final Value<String> note;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.note = const Value.absent(),
  });
  PeopleCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    required String icon,
    required int color,
    this.note = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       color = Value(color);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (note != null) 'note': note,
    });
  }

  PeopleCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String>? icon,
    Value<int>? color,
    Value<String>? note,
  }) {
    return PeopleCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $SplitsTable extends Splits with TableInfo<$SplitsTable, SplitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES people (id)',
    ),
  );
  static const VerificationMeta _shareMeta = const VerificationMeta('share');
  @override
  late final GeneratedColumn<int> share = GeneratedColumn<int>(
    'share',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    personId,
    share,
    note,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<SplitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('share')) {
      context.handle(
        _shareMeta,
        share.isAcceptableOrUnknown(data['share']!, _shareMeta),
      );
    } else if (isInserting) {
      context.missing(_shareMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SplitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SplitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      )!,
      share: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}share'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $SplitsTable createAlias(String alias) {
    return $SplitsTable(attachedDatabase, alias);
  }
}

class SplitRow extends DataClass implements Insertable<SplitRow> {
  final int id;
  final int? transactionId;
  final int personId;

  /// Positive = they owe me, negative = I owe them.
  final int share;
  final String note;
  final DateTime occurredAt;
  const SplitRow({
    required this.id,
    this.transactionId,
    required this.personId,
    required this.share,
    required this.note,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    map['person_id'] = Variable<int>(personId);
    map['share'] = Variable<int>(share);
    map['note'] = Variable<String>(note);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  SplitsCompanion toCompanion(bool nullToAbsent) {
    return SplitsCompanion(
      id: Value(id),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      personId: Value(personId),
      share: Value(share),
      note: Value(note),
      occurredAt: Value(occurredAt),
    );
  }

  factory SplitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SplitRow(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      personId: serializer.fromJson<int>(json['personId']),
      share: serializer.fromJson<int>(json['share']),
      note: serializer.fromJson<String>(json['note']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int?>(transactionId),
      'personId': serializer.toJson<int>(personId),
      'share': serializer.toJson<int>(share),
      'note': serializer.toJson<String>(note),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  SplitRow copyWith({
    int? id,
    Value<int?> transactionId = const Value.absent(),
    int? personId,
    int? share,
    String? note,
    DateTime? occurredAt,
  }) => SplitRow(
    id: id ?? this.id,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    personId: personId ?? this.personId,
    share: share ?? this.share,
    note: note ?? this.note,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  SplitRow copyWithCompanion(SplitsCompanion data) {
    return SplitRow(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      personId: data.personId.present ? data.personId.value : this.personId,
      share: data.share.present ? data.share.value : this.share,
      note: data.note.present ? data.note.value : this.note,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SplitRow(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('personId: $personId, ')
          ..write('share: $share, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transactionId, personId, share, note, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SplitRow &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.personId == this.personId &&
          other.share == this.share &&
          other.note == this.note &&
          other.occurredAt == this.occurredAt);
}

class SplitsCompanion extends UpdateCompanion<SplitRow> {
  final Value<int> id;
  final Value<int?> transactionId;
  final Value<int> personId;
  final Value<int> share;
  final Value<String> note;
  final Value<DateTime> occurredAt;
  const SplitsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.personId = const Value.absent(),
    this.share = const Value.absent(),
    this.note = const Value.absent(),
    this.occurredAt = const Value.absent(),
  });
  SplitsCompanion.insert({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    required int personId,
    required int share,
    this.note = const Value.absent(),
    required DateTime occurredAt,
  }) : personId = Value(personId),
       share = Value(share),
       occurredAt = Value(occurredAt);
  static Insertable<SplitRow> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? personId,
    Expression<int>? share,
    Expression<String>? note,
    Expression<DateTime>? occurredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (personId != null) 'person_id': personId,
      if (share != null) 'share': share,
      if (note != null) 'note': note,
      if (occurredAt != null) 'occurred_at': occurredAt,
    });
  }

  SplitsCompanion copyWith({
    Value<int>? id,
    Value<int?>? transactionId,
    Value<int>? personId,
    Value<int>? share,
    Value<String>? note,
    Value<DateTime>? occurredAt,
  }) {
    return SplitsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      personId: personId ?? this.personId,
      share: share ?? this.share,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (share.present) {
      map['share'] = Variable<int>(share.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('personId: $personId, ')
          ..write('share: $share, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }
}

class $SettlementsTable extends Settlements
    with TableInfo<$SettlementsTable, Settlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES people (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personId,
    amount,
    occurredAt,
    note,
    transactionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Settlement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Settlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Settlement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
    );
  }

  @override
  $SettlementsTable createAlias(String alias) {
    return $SettlementsTable(attachedDatabase, alias);
  }
}

class Settlement extends DataClass implements Insertable<Settlement> {
  final int id;
  final int personId;

  /// Positive = they paid me.
  final int amount;
  final DateTime occurredAt;
  final String note;
  final int? transactionId;
  const Settlement({
    required this.id,
    required this.personId,
    required this.amount,
    required this.occurredAt,
    required this.note,
    this.transactionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['amount'] = Variable<int>(amount);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    return map;
  }

  SettlementsCompanion toCompanion(bool nullToAbsent) {
    return SettlementsCompanion(
      id: Value(id),
      personId: Value(personId),
      amount: Value(amount),
      occurredAt: Value(occurredAt),
      note: Value(note),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
    );
  }

  factory Settlement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Settlement(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      amount: serializer.fromJson<int>(json['amount']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String>(json['note']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'amount': serializer.toJson<int>(amount),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String>(note),
      'transactionId': serializer.toJson<int?>(transactionId),
    };
  }

  Settlement copyWith({
    int? id,
    int? personId,
    int? amount,
    DateTime? occurredAt,
    String? note,
    Value<int?> transactionId = const Value.absent(),
  }) => Settlement(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    amount: amount ?? this.amount,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note ?? this.note,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
  );
  Settlement copyWithCompanion(SettlementsCompanion data) {
    return Settlement(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      amount: data.amount.present ? data.amount.value : this.amount,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Settlement(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personId, amount, occurredAt, note, transactionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settlement &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.amount == this.amount &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.transactionId == this.transactionId);
}

class SettlementsCompanion extends UpdateCompanion<Settlement> {
  final Value<int> id;
  final Value<int> personId;
  final Value<int> amount;
  final Value<DateTime> occurredAt;
  final Value<String> note;
  final Value<int?> transactionId;
  const SettlementsCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.amount = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.transactionId = const Value.absent(),
  });
  SettlementsCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required int amount,
    required DateTime occurredAt,
    this.note = const Value.absent(),
    this.transactionId = const Value.absent(),
  }) : personId = Value(personId),
       amount = Value(amount),
       occurredAt = Value(occurredAt);
  static Insertable<Settlement> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<int>? amount,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<int>? transactionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (amount != null) 'amount': amount,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (transactionId != null) 'transaction_id': transactionId,
    });
  }

  SettlementsCompanion copyWith({
    Value<int>? id,
    Value<int>? personId,
    Value<int>? amount,
    Value<DateTime>? occurredAt,
    Value<String>? note,
    Value<int?>? transactionId,
  }) {
    return SettlementsCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      amount: amount ?? this.amount,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettlementsCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _monthlyLimitMeta = const VerificationMeta(
    'monthlyLimit',
  );
  @override
  late final GeneratedColumn<int> monthlyLimit = GeneratedColumn<int>(
    'monthly_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromYmMeta = const VerificationMeta('fromYm');
  @override
  late final GeneratedColumn<int> fromYm = GeneratedColumn<int>(
    'from_ym',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toYmMeta = const VerificationMeta('toYm');
  @override
  late final GeneratedColumn<int> toYm = GeneratedColumn<int>(
    'to_ym',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    monthlyLimit,
    fromYm,
    toYm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('monthly_limit')) {
      context.handle(
        _monthlyLimitMeta,
        monthlyLimit.isAcceptableOrUnknown(
          data['monthly_limit']!,
          _monthlyLimitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyLimitMeta);
    }
    if (data.containsKey('from_ym')) {
      context.handle(
        _fromYmMeta,
        fromYm.isAcceptableOrUnknown(data['from_ym']!, _fromYmMeta),
      );
    } else if (isInserting) {
      context.missing(_fromYmMeta);
    }
    if (data.containsKey('to_ym')) {
      context.handle(
        _toYmMeta,
        toYm.isAcceptableOrUnknown(data['to_ym']!, _toYmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      monthlyLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_limit'],
      )!,
      fromYm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_ym'],
      )!,
      toYm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_ym'],
      ),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final int categoryId;
  final int monthlyLimit;
  final int fromYm;
  final int? toYm;
  const Budget({
    required this.id,
    required this.categoryId,
    required this.monthlyLimit,
    required this.fromYm,
    this.toYm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['monthly_limit'] = Variable<int>(monthlyLimit);
    map['from_ym'] = Variable<int>(fromYm);
    if (!nullToAbsent || toYm != null) {
      map['to_ym'] = Variable<int>(toYm);
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      monthlyLimit: Value(monthlyLimit),
      fromYm: Value(fromYm),
      toYm: toYm == null && nullToAbsent ? const Value.absent() : Value(toYm),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      monthlyLimit: serializer.fromJson<int>(json['monthlyLimit']),
      fromYm: serializer.fromJson<int>(json['fromYm']),
      toYm: serializer.fromJson<int?>(json['toYm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'monthlyLimit': serializer.toJson<int>(monthlyLimit),
      'fromYm': serializer.toJson<int>(fromYm),
      'toYm': serializer.toJson<int?>(toYm),
    };
  }

  Budget copyWith({
    int? id,
    int? categoryId,
    int? monthlyLimit,
    int? fromYm,
    Value<int?> toYm = const Value.absent(),
  }) => Budget(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    monthlyLimit: monthlyLimit ?? this.monthlyLimit,
    fromYm: fromYm ?? this.fromYm,
    toYm: toYm.present ? toYm.value : this.toYm,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      monthlyLimit: data.monthlyLimit.present
          ? data.monthlyLimit.value
          : this.monthlyLimit,
      fromYm: data.fromYm.present ? data.fromYm.value : this.fromYm,
      toYm: data.toYm.present ? data.toYm.value : this.toYm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('monthlyLimit: $monthlyLimit, ')
          ..write('fromYm: $fromYm, ')
          ..write('toYm: $toYm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, monthlyLimit, fromYm, toYm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.monthlyLimit == this.monthlyLimit &&
          other.fromYm == this.fromYm &&
          other.toYm == this.toYm);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<int> monthlyLimit;
  final Value<int> fromYm;
  final Value<int?> toYm;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.monthlyLimit = const Value.absent(),
    this.fromYm = const Value.absent(),
    this.toYm = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required int monthlyLimit,
    required int fromYm,
    this.toYm = const Value.absent(),
  }) : categoryId = Value(categoryId),
       monthlyLimit = Value(monthlyLimit),
       fromYm = Value(fromYm);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<int>? monthlyLimit,
    Expression<int>? fromYm,
    Expression<int>? toYm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (monthlyLimit != null) 'monthly_limit': monthlyLimit,
      if (fromYm != null) 'from_ym': fromYm,
      if (toYm != null) 'to_ym': toYm,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<int>? monthlyLimit,
    Value<int>? fromYm,
    Value<int?>? toYm,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      fromYm: fromYm ?? this.fromYm,
      toYm: toYm ?? this.toYm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (monthlyLimit.present) {
      map['monthly_limit'] = Variable<int>(monthlyLimit.value);
    }
    if (fromYm.present) {
      map['from_ym'] = Variable<int>(fromYm.value);
    }
    if (toYm.present) {
      map['to_ym'] = Variable<int>(toYm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('monthlyLimit: $monthlyLimit, ')
          ..write('fromYm: $fromYm, ')
          ..write('toYm: $toYm')
          ..write(')'))
        .toString();
  }
}

class $RecurringsTable extends Recurrings
    with TableInfo<$RecurringsTable, Recurring> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _expectedAmountMeta = const VerificationMeta(
    'expectedAmount',
  );
  @override
  late final GeneratedColumn<int> expectedAmount = GeneratedColumn<int>(
    'expected_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodDaysMeta = const VerificationMeta(
    'periodDays',
  );
  @override
  late final GeneratedColumn<int> periodDays = GeneratedColumn<int>(
    'period_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueMeta = const VerificationMeta(
    'nextDue',
  );
  @override
  late final GeneratedColumn<DateTime> nextDue = GeneratedColumn<DateTime>(
    'next_due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _confirmedMeta = const VerificationMeta(
    'confirmed',
  );
  @override
  late final GeneratedColumn<bool> confirmed = GeneratedColumn<bool>(
    'confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dismissedMeta = const VerificationMeta(
    'dismissed',
  );
  @override
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
    'dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    expectedAmount,
    periodDays,
    nextDue,
    categoryId,
    confirmed,
    dismissed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recurring> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('expected_amount')) {
      context.handle(
        _expectedAmountMeta,
        expectedAmount.isAcceptableOrUnknown(
          data['expected_amount']!,
          _expectedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedAmountMeta);
    }
    if (data.containsKey('period_days')) {
      context.handle(
        _periodDaysMeta,
        periodDays.isAcceptableOrUnknown(data['period_days']!, _periodDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_periodDaysMeta);
    }
    if (data.containsKey('next_due')) {
      context.handle(
        _nextDueMeta,
        nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta),
      );
    } else if (isInserting) {
      context.missing(_nextDueMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('confirmed')) {
      context.handle(
        _confirmedMeta,
        confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta),
      );
    }
    if (data.containsKey('dismissed')) {
      context.handle(
        _dismissedMeta,
        dismissed.isAcceptableOrUnknown(data['dismissed']!, _dismissedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recurring map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recurring(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      expectedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount'],
      )!,
      periodDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_days'],
      )!,
      nextDue: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      confirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confirmed'],
      )!,
      dismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dismissed'],
      )!,
    );
  }

  @override
  $RecurringsTable createAlias(String alias) {
    return $RecurringsTable(attachedDatabase, alias);
  }
}

class Recurring extends DataClass implements Insertable<Recurring> {
  final int id;
  final int accountId;
  final int expectedAmount;
  final int periodDays;
  final DateTime nextDue;
  final int? categoryId;
  final bool confirmed;
  final bool dismissed;
  const Recurring({
    required this.id,
    required this.accountId,
    required this.expectedAmount,
    required this.periodDays,
    required this.nextDue,
    this.categoryId,
    required this.confirmed,
    required this.dismissed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['expected_amount'] = Variable<int>(expectedAmount);
    map['period_days'] = Variable<int>(periodDays);
    map['next_due'] = Variable<DateTime>(nextDue);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['confirmed'] = Variable<bool>(confirmed);
    map['dismissed'] = Variable<bool>(dismissed);
    return map;
  }

  RecurringsCompanion toCompanion(bool nullToAbsent) {
    return RecurringsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      expectedAmount: Value(expectedAmount),
      periodDays: Value(periodDays),
      nextDue: Value(nextDue),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      confirmed: Value(confirmed),
      dismissed: Value(dismissed),
    );
  }

  factory Recurring.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recurring(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      expectedAmount: serializer.fromJson<int>(json['expectedAmount']),
      periodDays: serializer.fromJson<int>(json['periodDays']),
      nextDue: serializer.fromJson<DateTime>(json['nextDue']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'expectedAmount': serializer.toJson<int>(expectedAmount),
      'periodDays': serializer.toJson<int>(periodDays),
      'nextDue': serializer.toJson<DateTime>(nextDue),
      'categoryId': serializer.toJson<int?>(categoryId),
      'confirmed': serializer.toJson<bool>(confirmed),
      'dismissed': serializer.toJson<bool>(dismissed),
    };
  }

  Recurring copyWith({
    int? id,
    int? accountId,
    int? expectedAmount,
    int? periodDays,
    DateTime? nextDue,
    Value<int?> categoryId = const Value.absent(),
    bool? confirmed,
    bool? dismissed,
  }) => Recurring(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    expectedAmount: expectedAmount ?? this.expectedAmount,
    periodDays: periodDays ?? this.periodDays,
    nextDue: nextDue ?? this.nextDue,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    confirmed: confirmed ?? this.confirmed,
    dismissed: dismissed ?? this.dismissed,
  );
  Recurring copyWithCompanion(RecurringsCompanion data) {
    return Recurring(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      expectedAmount: data.expectedAmount.present
          ? data.expectedAmount.value
          : this.expectedAmount,
      periodDays: data.periodDays.present
          ? data.periodDays.value
          : this.periodDays,
      nextDue: data.nextDue.present ? data.nextDue.value : this.nextDue,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      confirmed: data.confirmed.present ? data.confirmed.value : this.confirmed,
      dismissed: data.dismissed.present ? data.dismissed.value : this.dismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recurring(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('periodDays: $periodDays, ')
          ..write('nextDue: $nextDue, ')
          ..write('categoryId: $categoryId, ')
          ..write('confirmed: $confirmed, ')
          ..write('dismissed: $dismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    expectedAmount,
    periodDays,
    nextDue,
    categoryId,
    confirmed,
    dismissed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recurring &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.expectedAmount == this.expectedAmount &&
          other.periodDays == this.periodDays &&
          other.nextDue == this.nextDue &&
          other.categoryId == this.categoryId &&
          other.confirmed == this.confirmed &&
          other.dismissed == this.dismissed);
}

class RecurringsCompanion extends UpdateCompanion<Recurring> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int> expectedAmount;
  final Value<int> periodDays;
  final Value<DateTime> nextDue;
  final Value<int?> categoryId;
  final Value<bool> confirmed;
  final Value<bool> dismissed;
  const RecurringsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.expectedAmount = const Value.absent(),
    this.periodDays = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.dismissed = const Value.absent(),
  });
  RecurringsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required int expectedAmount,
    required int periodDays,
    required DateTime nextDue,
    this.categoryId = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.dismissed = const Value.absent(),
  }) : accountId = Value(accountId),
       expectedAmount = Value(expectedAmount),
       periodDays = Value(periodDays),
       nextDue = Value(nextDue);
  static Insertable<Recurring> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? expectedAmount,
    Expression<int>? periodDays,
    Expression<DateTime>? nextDue,
    Expression<int>? categoryId,
    Expression<bool>? confirmed,
    Expression<bool>? dismissed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (expectedAmount != null) 'expected_amount': expectedAmount,
      if (periodDays != null) 'period_days': periodDays,
      if (nextDue != null) 'next_due': nextDue,
      if (categoryId != null) 'category_id': categoryId,
      if (confirmed != null) 'confirmed': confirmed,
      if (dismissed != null) 'dismissed': dismissed,
    });
  }

  RecurringsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int>? expectedAmount,
    Value<int>? periodDays,
    Value<DateTime>? nextDue,
    Value<int?>? categoryId,
    Value<bool>? confirmed,
    Value<bool>? dismissed,
  }) {
    return RecurringsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      periodDays: periodDays ?? this.periodDays,
      nextDue: nextDue ?? this.nextDue,
      categoryId: categoryId ?? this.categoryId,
      confirmed: confirmed ?? this.confirmed,
      dismissed: dismissed ?? this.dismissed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (expectedAmount.present) {
      map['expected_amount'] = Variable<int>(expectedAmount.value);
    }
    if (periodDays.present) {
      map['period_days'] = Variable<int>(periodDays.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<DateTime>(nextDue.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    if (dismissed.present) {
      map['dismissed'] = Variable<bool>(dismissed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('periodDays: $periodDays, ')
          ..write('nextDue: $nextDue, ')
          ..write('categoryId: $categoryId, ')
          ..write('confirmed: $confirmed, ')
          ..write('dismissed: $dismissed')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReminderTarget, String>
  targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ReminderTarget>($RemindersTable.$convertertargetType);
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<int> targetId = GeneratedColumn<int>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetType,
    targetId,
    at,
    body,
    done,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetType: $RemindersTable.$convertertargetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_type'],
        )!,
      ),
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderTarget, String, String>
  $convertertargetType = const EnumNameConverter<ReminderTarget>(
    ReminderTarget.values,
  );
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final ReminderTarget targetType;
  final int targetId;
  final DateTime at;
  final String body;
  final bool done;
  const Reminder({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.at,
    required this.body,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['target_type'] = Variable<String>(
        $RemindersTable.$convertertargetType.toSql(targetType),
      );
    }
    map['target_id'] = Variable<int>(targetId);
    map['at'] = Variable<DateTime>(at);
    map['body'] = Variable<String>(body);
    map['done'] = Variable<bool>(done);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      targetType: Value(targetType),
      targetId: Value(targetId),
      at: Value(at),
      body: Value(body),
      done: Value(done),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      targetType: $RemindersTable.$convertertargetType.fromJson(
        serializer.fromJson<String>(json['targetType']),
      ),
      targetId: serializer.fromJson<int>(json['targetId']),
      at: serializer.fromJson<DateTime>(json['at']),
      body: serializer.fromJson<String>(json['body']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetType': serializer.toJson<String>(
        $RemindersTable.$convertertargetType.toJson(targetType),
      ),
      'targetId': serializer.toJson<int>(targetId),
      'at': serializer.toJson<DateTime>(at),
      'body': serializer.toJson<String>(body),
      'done': serializer.toJson<bool>(done),
    };
  }

  Reminder copyWith({
    int? id,
    ReminderTarget? targetType,
    int? targetId,
    DateTime? at,
    String? body,
    bool? done,
  }) => Reminder(
    id: id ?? this.id,
    targetType: targetType ?? this.targetType,
    targetId: targetId ?? this.targetId,
    at: at ?? this.at,
    body: body ?? this.body,
    done: done ?? this.done,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      at: data.at.present ? data.at.value : this.at,
      body: data.body.present ? data.body.value : this.body,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('at: $at, ')
          ..write('body: $body, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, targetType, targetId, at, body, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.targetType == this.targetType &&
          other.targetId == this.targetId &&
          other.at == this.at &&
          other.body == this.body &&
          other.done == this.done);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<ReminderTarget> targetType;
  final Value<int> targetId;
  final Value<DateTime> at;
  final Value<String> body;
  final Value<bool> done;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetId = const Value.absent(),
    this.at = const Value.absent(),
    this.body = const Value.absent(),
    this.done = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required ReminderTarget targetType,
    required int targetId,
    required DateTime at,
    this.body = const Value.absent(),
    this.done = const Value.absent(),
  }) : targetType = Value(targetType),
       targetId = Value(targetId),
       at = Value(at);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? targetType,
    Expression<int>? targetId,
    Expression<DateTime>? at,
    Expression<String>? body,
    Expression<bool>? done,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetType != null) 'target_type': targetType,
      if (targetId != null) 'target_id': targetId,
      if (at != null) 'at': at,
      if (body != null) 'body': body,
      if (done != null) 'done': done,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<ReminderTarget>? targetType,
    Value<int>? targetId,
    Value<DateTime>? at,
    Value<String>? body,
    Value<bool>? done,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      at: at ?? this.at,
      body: body ?? this.body,
      done: done ?? this.done,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(
        $RemindersTable.$convertertargetType.toSql(targetType.value),
      );
    }
    if (targetId.present) {
      map['target_id'] = Variable<int>(targetId.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('at: $at, ')
          ..write('body: $body, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }
}

class $InboxItemsTable extends InboxItems
    with TableInfo<$InboxItemsTable, InboxItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InboxItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    title,
    body,
    payload,
    createdAt,
    read,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inbox_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InboxItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InboxItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InboxItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
    );
  }

  @override
  $InboxItemsTable createAlias(String alias) {
    return $InboxItemsTable(attachedDatabase, alias);
  }
}

class InboxItem extends DataClass implements Insertable<InboxItem> {
  final int id;

  /// capture | reminder | budget | leak | summary | transfer
  final String kind;
  final String title;
  final String body;

  /// Where tapping goes: `tx:12`, `person:3`, `review`, `reports`...
  final String? payload;
  final DateTime createdAt;
  final bool read;
  const InboxItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    this.payload,
    required this.createdAt,
    required this.read,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['read'] = Variable<bool>(read);
    return map;
  }

  InboxItemsCompanion toCompanion(bool nullToAbsent) {
    return InboxItemsCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      body: Value(body),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      createdAt: Value(createdAt),
      read: Value(read),
    );
  }

  factory InboxItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InboxItem(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      read: serializer.fromJson<bool>(json['read']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'read': serializer.toJson<bool>(read),
    };
  }

  InboxItem copyWith({
    int? id,
    String? kind,
    String? title,
    String? body,
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
    bool? read,
  }) => InboxItem(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    body: body ?? this.body,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
    read: read ?? this.read,
  );
  InboxItem copyWithCompanion(InboxItemsCompanion data) {
    return InboxItem(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      read: data.read.present ? data.read.value : this.read,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InboxItem(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('read: $read')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, title, body, payload, createdAt, read);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InboxItem &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.body == this.body &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.read == this.read);
}

class InboxItemsCompanion extends UpdateCompanion<InboxItem> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  final Value<bool> read;
  const InboxItemsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.read = const Value.absent(),
  });
  InboxItemsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String title,
    this.body = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.read = const Value.absent(),
  }) : kind = Value(kind),
       title = Value(title);
  static Insertable<InboxItem> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<bool>? read,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (read != null) 'read': read,
    });
  }

  InboxItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? title,
    Value<String>? body,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
    Value<bool>? read,
  }) {
    return InboxItemsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InboxItemsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('read: $read')
          ..write(')'))
        .toString();
  }
}

class $TransferProposalsTable extends TransferProposals
    with TableInfo<$TransferProposalsTable, TransferProposal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransferProposalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _outTxIdMeta = const VerificationMeta(
    'outTxId',
  );
  @override
  late final GeneratedColumn<int> outTxId = GeneratedColumn<int>(
    'out_tx_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _inTxIdMeta = const VerificationMeta('inTxId');
  @override
  late final GeneratedColumn<int> inTxId = GeneratedColumn<int>(
    'in_tx_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, outTxId, inTxId, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer_proposals';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransferProposal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('out_tx_id')) {
      context.handle(
        _outTxIdMeta,
        outTxId.isAcceptableOrUnknown(data['out_tx_id']!, _outTxIdMeta),
      );
    } else if (isInserting) {
      context.missing(_outTxIdMeta);
    }
    if (data.containsKey('in_tx_id')) {
      context.handle(
        _inTxIdMeta,
        inTxId.isAcceptableOrUnknown(data['in_tx_id']!, _inTxIdMeta),
      );
    } else if (isInserting) {
      context.missing(_inTxIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferProposal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferProposal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      outTxId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}out_tx_id'],
      )!,
      inTxId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}in_tx_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $TransferProposalsTable createAlias(String alias) {
    return $TransferProposalsTable(attachedDatabase, alias);
  }
}

class TransferProposal extends DataClass
    implements Insertable<TransferProposal> {
  final int id;
  final int outTxId;
  final int inTxId;

  /// pending | confirmed | dismissed
  final String status;
  const TransferProposal({
    required this.id,
    required this.outTxId,
    required this.inTxId,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['out_tx_id'] = Variable<int>(outTxId);
    map['in_tx_id'] = Variable<int>(inTxId);
    map['status'] = Variable<String>(status);
    return map;
  }

  TransferProposalsCompanion toCompanion(bool nullToAbsent) {
    return TransferProposalsCompanion(
      id: Value(id),
      outTxId: Value(outTxId),
      inTxId: Value(inTxId),
      status: Value(status),
    );
  }

  factory TransferProposal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferProposal(
      id: serializer.fromJson<int>(json['id']),
      outTxId: serializer.fromJson<int>(json['outTxId']),
      inTxId: serializer.fromJson<int>(json['inTxId']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'outTxId': serializer.toJson<int>(outTxId),
      'inTxId': serializer.toJson<int>(inTxId),
      'status': serializer.toJson<String>(status),
    };
  }

  TransferProposal copyWith({
    int? id,
    int? outTxId,
    int? inTxId,
    String? status,
  }) => TransferProposal(
    id: id ?? this.id,
    outTxId: outTxId ?? this.outTxId,
    inTxId: inTxId ?? this.inTxId,
    status: status ?? this.status,
  );
  TransferProposal copyWithCompanion(TransferProposalsCompanion data) {
    return TransferProposal(
      id: data.id.present ? data.id.value : this.id,
      outTxId: data.outTxId.present ? data.outTxId.value : this.outTxId,
      inTxId: data.inTxId.present ? data.inTxId.value : this.inTxId,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferProposal(')
          ..write('id: $id, ')
          ..write('outTxId: $outTxId, ')
          ..write('inTxId: $inTxId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, outTxId, inTxId, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferProposal &&
          other.id == this.id &&
          other.outTxId == this.outTxId &&
          other.inTxId == this.inTxId &&
          other.status == this.status);
}

class TransferProposalsCompanion extends UpdateCompanion<TransferProposal> {
  final Value<int> id;
  final Value<int> outTxId;
  final Value<int> inTxId;
  final Value<String> status;
  const TransferProposalsCompanion({
    this.id = const Value.absent(),
    this.outTxId = const Value.absent(),
    this.inTxId = const Value.absent(),
    this.status = const Value.absent(),
  });
  TransferProposalsCompanion.insert({
    this.id = const Value.absent(),
    required int outTxId,
    required int inTxId,
    this.status = const Value.absent(),
  }) : outTxId = Value(outTxId),
       inTxId = Value(inTxId);
  static Insertable<TransferProposal> custom({
    Expression<int>? id,
    Expression<int>? outTxId,
    Expression<int>? inTxId,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (outTxId != null) 'out_tx_id': outTxId,
      if (inTxId != null) 'in_tx_id': inTxId,
      if (status != null) 'status': status,
    });
  }

  TransferProposalsCompanion copyWith({
    Value<int>? id,
    Value<int>? outTxId,
    Value<int>? inTxId,
    Value<String>? status,
  }) {
    return TransferProposalsCompanion(
      id: id ?? this.id,
      outTxId: outTxId ?? this.outTxId,
      inTxId: inTxId ?? this.inTxId,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (outTxId.present) {
      map['out_tx_id'] = Variable<int>(outTxId.value);
    }
    if (inTxId.present) {
      map['in_tx_id'] = Variable<int>(inTxId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferProposalsCompanion(')
          ..write('id: $id, ')
          ..write('outTxId: $outTxId, ')
          ..write('inTxId: $inTxId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $BanksTable banks = $BanksTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $SmsSendersTable smsSenders = $SmsSendersTable(this);
  late final $SmsTemplatesTable smsTemplates = $SmsTemplatesTable(this);
  late final $RawSmsTable rawSms = $RawSmsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionTagsTable transactionTags = $TransactionTagsTable(
    this,
  );
  late final $PeopleTable people = $PeopleTable(this);
  late final $SplitsTable splits = $SplitsTable(this);
  late final $SettlementsTable settlements = $SettlementsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $RecurringsTable recurrings = $RecurringsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $InboxItemsTable inboxItems = $InboxItemsTable(this);
  late final $TransferProposalsTable transferProposals =
      $TransferProposalsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final Index rawSmsStatus = Index(
    'raw_sms_status',
    'CREATE INDEX raw_sms_status ON raw_sms (status)',
  );
  late final Index txTime = Index(
    'tx_time',
    'CREATE INDEX tx_time ON transactions (occurred_at, id)',
  );
  late final Index txAccountTime = Index(
    'tx_account_time',
    'CREATE INDEX tx_account_time ON transactions (account_id, occurred_at)',
  );
  late final Index txMonthCategory = Index(
    'tx_month_category',
    'CREATE INDEX tx_month_category ON transactions (jalali_ym, category_id)',
  );
  late final Index txCategory = Index(
    'tx_category',
    'CREATE INDEX tx_category ON transactions (category_id)',
  );
  late final Index txDeleted = Index(
    'tx_deleted',
    'CREATE INDEX tx_deleted ON transactions (deleted_at)',
  );
  late final Index splitPerson = Index(
    'split_person',
    'CREATE INDEX split_person ON splits (person_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    banks,
    accounts,
    smsSenders,
    smsTemplates,
    rawSms,
    categories,
    tags,
    transactions,
    transactionTags,
    people,
    splits,
    settlements,
    budgets,
    recurrings,
    reminders,
    inboxItems,
    transferProposals,
    settings,
    rawSmsStatus,
    txTime,
    txAccountTime,
    txMonthCategory,
    txCategory,
    txDeleted,
    splitPerson,
  ];
}

typedef $$BanksTableCreateCompanionBuilder = BanksCompanion Function({
  Value<int> id,
  required String code,
  required String nameEn,
  required String nameFa,
  Value<String> icon,
});
typedef $$BanksTableUpdateCompanionBuilder = BanksCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> nameEn,
  Value<String> nameFa,
  Value<String> icon,
});

final class $$BanksTableReferences
    extends BaseReferences<_$AppDb, $BanksTable, Bank> {
  $$BanksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: 'banks__id__accounts__bank_id',
  );

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.bankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SmsSendersTable, List<SmsSender>>
  _smsSendersRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.smsSenders,
    aliasName: 'banks__id__sms_senders__bank_id',
  );

  $$SmsSendersTableProcessedTableManager get smsSendersRefs {
    final manager = $$SmsSendersTableTableManager(
      $_db,
      $_db.smsSenders,
    ).filter((f) => f.bankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_smsSendersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SmsTemplatesTable, List<SmsTemplateRow>>
  _smsTemplatesRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.smsTemplates,
    aliasName: 'banks__id__sms_templates__bank_id',
  );

  $$SmsTemplatesTableProcessedTableManager get smsTemplatesRefs {
    final manager = $$SmsTemplatesTableTableManager(
      $_db,
      $_db.smsTemplates,
    ).filter((f) => f.bankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_smsTemplatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BanksTableFilterComposer extends Composer<_$AppDb, $BanksTable> {
  $$BanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFa => $composableBuilder(
    column: $table.nameFa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> accountsRefs(
    Expression<bool> Function($$AccountsTableFilterComposer f) f,
  ) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> smsSendersRefs(
    Expression<bool> Function($$SmsSendersTableFilterComposer f) f,
  ) {
    final $$SmsSendersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsSenders,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSendersTableFilterComposer(
            $db: $db,
            $table: $db.smsSenders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> smsTemplatesRefs(
    Expression<bool> Function($$SmsTemplatesTableFilterComposer f) f,
  ) {
    final $$SmsTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsTemplates,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.smsTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BanksTableOrderingComposer extends Composer<_$AppDb, $BanksTable> {
  $$BanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFa => $composableBuilder(
    column: $table.nameFa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BanksTableAnnotationComposer extends Composer<_$AppDb, $BanksTable> {
  $$BanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($$AccountsTableAnnotationComposer a) f,
  ) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> smsSendersRefs<T extends Object>(
    Expression<T> Function($$SmsSendersTableAnnotationComposer a) f,
  ) {
    final $$SmsSendersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsSenders,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSendersTableAnnotationComposer(
            $db: $db,
            $table: $db.smsSenders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> smsTemplatesRefs<T extends Object>(
    Expression<T> Function($$SmsTemplatesTableAnnotationComposer a) f,
  ) {
    final $$SmsTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsTemplates,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.smsTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BanksTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $BanksTable,
          Bank,
          $$BanksTableFilterComposer,
          $$BanksTableOrderingComposer,
          $$BanksTableAnnotationComposer,
          $$BanksTableCreateCompanionBuilder,
          $$BanksTableUpdateCompanionBuilder,
          (Bank, $$BanksTableReferences),
          Bank,
          PrefetchHooks Function({
            bool accountsRefs,
            bool smsSendersRefs,
            bool smsTemplatesRefs,
          })
        > {
  $$BanksTableTableManager(_$AppDb db, $BanksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameFa = const Value.absent(),
                Value<String> icon = const Value.absent(),
              }) => BanksCompanion(
                id: id,
                code: code,
                nameEn: nameEn,
                nameFa: nameFa,
                icon: icon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameEn,
                required String nameFa,
                Value<String> icon = const Value.absent(),
              }) => BanksCompanion.insert(
                id: id,
                code: code,
                nameEn: nameEn,
                nameFa: nameFa,
                icon: icon,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BanksTable, Bank>(table),
                  $$BanksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountsRefs = false,
                smsSendersRefs = false,
                smsTemplatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (accountsRefs) db.accounts,
                    if (smsSendersRefs) db.smsSenders,
                    if (smsTemplatesRefs) db.smsTemplates,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (accountsRefs)
                        await $_getPrefetchedDataByColumns<
                          Bank,
                          $BanksTable,
                          Account,
                          $AccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BanksTableReferences
                              ._accountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BanksTableReferences(
                                db,
                                table,
                                p0,
                              ).accountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_id',
                          typedResults: items,
                        ),
                      if (smsSendersRefs)
                        await $_getPrefetchedDataByColumns<
                          Bank,
                          $BanksTable,
                          SmsSender,
                          $SmsSendersTable
                        >(
                          currentTable: table,
                          referencedTable: $$BanksTableReferences
                              ._smsSendersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BanksTableReferences(
                                db,
                                table,
                                p0,
                              ).smsSendersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_id',
                          typedResults: items,
                        ),
                      if (smsTemplatesRefs)
                        await $_getPrefetchedDataByColumns<
                          Bank,
                          $BanksTable,
                          SmsTemplateRow,
                          $SmsTemplatesTable
                        >(
                          currentTable: table,
                          referencedTable: $$BanksTableReferences
                              ._smsTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BanksTableReferences(
                                db,
                                table,
                                p0,
                              ).smsTemplatesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BanksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $BanksTable,
      Bank,
      $$BanksTableFilterComposer,
      $$BanksTableOrderingComposer,
      $$BanksTableAnnotationComposer,
      $$BanksTableCreateCompanionBuilder,
      $$BanksTableUpdateCompanionBuilder,
      (Bank, $$BanksTableReferences),
      Bank,
      PrefetchHooks Function({
        bool accountsRefs,
        bool smsSendersRefs,
        bool smsTemplatesRefs,
      })
    >;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> bankId,
  Value<String?> number,
  required AccountKind kind,
  required String icon,
  required int color,
  Value<int> openingBalance,
  Value<bool> archived,
  Value<int> sort,
  Value<int?> balanceSet,
  Value<DateTime?> balanceSetAt,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> bankId,
  Value<String?> number,
  Value<AccountKind> kind,
  Value<String> icon,
  Value<int> color,
  Value<int> openingBalance,
  Value<bool> archived,
  Value<int> sort,
  Value<int?> balanceSet,
  Value<DateTime?> balanceSetAt,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDb, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BanksTable _bankIdTable(_$AppDb db) =>
      db.banks.createAlias('accounts__bank_id__banks__id');

  $$BanksTableProcessedTableManager? get bankId {
    final $_column = $_itemColumn<int>('bank_id');
    if ($_column == null) return null;
    final manager = $$BanksTableTableManager(
      $_db,
      $_db.banks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurringsTable, List<Recurring>>
  _recurringsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.recurrings,
    aliasName: 'accounts__id__recurrings__account_id',
  );

  $$RecurringsTableProcessedTableManager get recurringsRefs {
    final manager = $$RecurringsTableTableManager(
      $_db,
      $_db.recurrings,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurringsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer extends Composer<_$AppDb, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountKind, AccountKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceSet => $composableBuilder(
    column: $table.balanceSet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get balanceSetAt => $composableBuilder(
    column: $table.balanceSetAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BanksTableFilterComposer get bankId {
    final $$BanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableFilterComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringsRefs(
    Expression<bool> Function($$RecurringsTableFilterComposer f) f,
  ) {
    final $$RecurringsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrings,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringsTableFilterComposer(
            $db: $db,
            $table: $db.recurrings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDb, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceSet => $composableBuilder(
    column: $table.balanceSet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get balanceSetAt => $composableBuilder(
    column: $table.balanceSetAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BanksTableOrderingComposer get bankId {
    final $$BanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableOrderingComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDb, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get sort =>
      $composableBuilder(column: $table.sort, builder: (column) => column);

  GeneratedColumn<int> get balanceSet => $composableBuilder(
    column: $table.balanceSet,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get balanceSetAt => $composableBuilder(
    column: $table.balanceSetAt,
    builder: (column) => column,
  );

  $$BanksTableAnnotationComposer get bankId {
    final $$BanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableAnnotationComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringsRefs<T extends Object>(
    Expression<T> Function($$RecurringsTableAnnotationComposer a) f,
  ) {
    final $$RecurringsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrings,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringsTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool bankId,
            bool transactionsRefs,
            bool recurringsRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDb db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> bankId = const Value.absent(),
                Value<String?> number = const Value.absent(),
                Value<AccountKind> kind = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sort = const Value.absent(),
                Value<int?> balanceSet = const Value.absent(),
                Value<DateTime?> balanceSetAt = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                bankId: bankId,
                number: number,
                kind: kind,
                icon: icon,
                color: color,
                openingBalance: openingBalance,
                archived: archived,
                sort: sort,
                balanceSet: balanceSet,
                balanceSetAt: balanceSetAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> bankId = const Value.absent(),
                Value<String?> number = const Value.absent(),
                required AccountKind kind,
                required String icon,
                required int color,
                Value<int> openingBalance = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sort = const Value.absent(),
                Value<int?> balanceSet = const Value.absent(),
                Value<DateTime?> balanceSetAt = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                bankId: bankId,
                number: number,
                kind: kind,
                icon: icon,
                color: color,
                openingBalance: openingBalance,
                archived: archived,
                sort: sort,
                balanceSet: balanceSet,
                balanceSetAt: balanceSetAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, Account>(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bankId = false,
                transactionsRefs = false,
                recurringsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (recurringsRefs) db.recurrings,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bankId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bankId,
                            referencedTable: $$AccountsTableReferences
                                ._bankIdTable(db),
                            referencedColumn: $$AccountsTableReferences
                                ._bankIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          Transaction,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (recurringsRefs)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          Recurring,
                          $RecurringsTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._recurringsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool bankId,
        bool transactionsRefs,
        bool recurringsRefs,
      })
    >;
typedef $$SmsSendersTableCreateCompanionBuilder = SmsSendersCompanion Function({
  Value<int> id,
  required String address,
  Value<int?> bankId,
  Value<bool> ignored,
});
typedef $$SmsSendersTableUpdateCompanionBuilder = SmsSendersCompanion Function({
  Value<int> id,
  Value<String> address,
  Value<int?> bankId,
  Value<bool> ignored,
});

final class $$SmsSendersTableReferences
    extends BaseReferences<_$AppDb, $SmsSendersTable, SmsSender> {
  $$SmsSendersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BanksTable _bankIdTable(_$AppDb db) =>
      db.banks.createAlias('sms_senders__bank_id__banks__id');

  $$BanksTableProcessedTableManager? get bankId {
    final $_column = $_itemColumn<int>('bank_id');
    if ($_column == null) return null;
    final manager = $$BanksTableTableManager(
      $_db,
      $_db.banks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SmsSendersTableFilterComposer
    extends Composer<_$AppDb, $SmsSendersTable> {
  $$SmsSendersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ignored => $composableBuilder(
    column: $table.ignored,
    builder: (column) => ColumnFilters(column),
  );

  $$BanksTableFilterComposer get bankId {
    final $$BanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableFilterComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsSendersTableOrderingComposer
    extends Composer<_$AppDb, $SmsSendersTable> {
  $$SmsSendersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ignored => $composableBuilder(
    column: $table.ignored,
    builder: (column) => ColumnOrderings(column),
  );

  $$BanksTableOrderingComposer get bankId {
    final $$BanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableOrderingComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsSendersTableAnnotationComposer
    extends Composer<_$AppDb, $SmsSendersTable> {
  $$SmsSendersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get ignored =>
      $composableBuilder(column: $table.ignored, builder: (column) => column);

  $$BanksTableAnnotationComposer get bankId {
    final $$BanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableAnnotationComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsSendersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SmsSendersTable,
          SmsSender,
          $$SmsSendersTableFilterComposer,
          $$SmsSendersTableOrderingComposer,
          $$SmsSendersTableAnnotationComposer,
          $$SmsSendersTableCreateCompanionBuilder,
          $$SmsSendersTableUpdateCompanionBuilder,
          (SmsSender, $$SmsSendersTableReferences),
          SmsSender,
          PrefetchHooks Function({bool bankId})
        > {
  $$SmsSendersTableTableManager(_$AppDb db, $SmsSendersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsSendersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsSendersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsSendersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int?> bankId = const Value.absent(),
                Value<bool> ignored = const Value.absent(),
              }) => SmsSendersCompanion(
                id: id,
                address: address,
                bankId: bankId,
                ignored: ignored,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String address,
                Value<int?> bankId = const Value.absent(),
                Value<bool> ignored = const Value.absent(),
              }) => SmsSendersCompanion.insert(
                id: id,
                address: address,
                bankId: bankId,
                ignored: ignored,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SmsSendersTable, SmsSender>(table),
                  $$SmsSendersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bankId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bankId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bankId,
                        referencedTable: $$SmsSendersTableReferences
                            ._bankIdTable(db),
                        referencedColumn: $$SmsSendersTableReferences
                            ._bankIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SmsSendersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SmsSendersTable,
      SmsSender,
      $$SmsSendersTableFilterComposer,
      $$SmsSendersTableOrderingComposer,
      $$SmsSendersTableAnnotationComposer,
      $$SmsSendersTableCreateCompanionBuilder,
      $$SmsSendersTableUpdateCompanionBuilder,
      (SmsSender, $$SmsSendersTableReferences),
      SmsSender,
      PrefetchHooks Function({bool bankId})
    >;
typedef $$SmsTemplatesTableCreateCompanionBuilder =
    SmsTemplatesCompanion Function({
      Value<int> id,
      required String code,
      Value<int?> bankId,
      Value<String?> sender,
      required String pattern,
      Value<String?> sample,
      Value<bool> builtin,
      Value<bool> verified,
      Value<bool> enabled,
      Value<int> priority,
    });
typedef $$SmsTemplatesTableUpdateCompanionBuilder =
    SmsTemplatesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<int?> bankId,
      Value<String?> sender,
      Value<String> pattern,
      Value<String?> sample,
      Value<bool> builtin,
      Value<bool> verified,
      Value<bool> enabled,
      Value<int> priority,
    });

final class $$SmsTemplatesTableReferences
    extends BaseReferences<_$AppDb, $SmsTemplatesTable, SmsTemplateRow> {
  $$SmsTemplatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BanksTable _bankIdTable(_$AppDb db) =>
      db.banks.createAlias('sms_templates__bank_id__banks__id');

  $$BanksTableProcessedTableManager? get bankId {
    final $_column = $_itemColumn<int>('bank_id');
    if ($_column == null) return null;
    final manager = $$BanksTableTableManager(
      $_db,
      $_db.banks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SmsTemplatesTableFilterComposer
    extends Composer<_$AppDb, $SmsTemplatesTable> {
  $$SmsTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sample => $composableBuilder(
    column: $table.sample,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  $$BanksTableFilterComposer get bankId {
    final $$BanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableFilterComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsTemplatesTableOrderingComposer
    extends Composer<_$AppDb, $SmsTemplatesTable> {
  $$SmsTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sample => $composableBuilder(
    column: $table.sample,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  $$BanksTableOrderingComposer get bankId {
    final $$BanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableOrderingComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsTemplatesTableAnnotationComposer
    extends Composer<_$AppDb, $SmsTemplatesTable> {
  $$SmsTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get sample =>
      $composableBuilder(column: $table.sample, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  $$BanksTableAnnotationComposer get bankId {
    final $$BanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableAnnotationComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SmsTemplatesTable,
          SmsTemplateRow,
          $$SmsTemplatesTableFilterComposer,
          $$SmsTemplatesTableOrderingComposer,
          $$SmsTemplatesTableAnnotationComposer,
          $$SmsTemplatesTableCreateCompanionBuilder,
          $$SmsTemplatesTableUpdateCompanionBuilder,
          (SmsTemplateRow, $$SmsTemplatesTableReferences),
          SmsTemplateRow,
          PrefetchHooks Function({bool bankId})
        > {
  $$SmsTemplatesTableTableManager(_$AppDb db, $SmsTemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int?> bankId = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<String?> sample = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> priority = const Value.absent(),
              }) => SmsTemplatesCompanion(
                id: id,
                code: code,
                bankId: bankId,
                sender: sender,
                pattern: pattern,
                sample: sample,
                builtin: builtin,
                verified: verified,
                enabled: enabled,
                priority: priority,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                Value<int?> bankId = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                required String pattern,
                Value<String?> sample = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> priority = const Value.absent(),
              }) => SmsTemplatesCompanion.insert(
                id: id,
                code: code,
                bankId: bankId,
                sender: sender,
                pattern: pattern,
                sample: sample,
                builtin: builtin,
                verified: verified,
                enabled: enabled,
                priority: priority,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SmsTemplatesTable, SmsTemplateRow>(table),
                  $$SmsTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bankId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bankId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bankId,
                        referencedTable: $$SmsTemplatesTableReferences
                            ._bankIdTable(db),
                        referencedColumn: $$SmsTemplatesTableReferences
                            ._bankIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SmsTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SmsTemplatesTable,
      SmsTemplateRow,
      $$SmsTemplatesTableFilterComposer,
      $$SmsTemplatesTableOrderingComposer,
      $$SmsTemplatesTableAnnotationComposer,
      $$SmsTemplatesTableCreateCompanionBuilder,
      $$SmsTemplatesTableUpdateCompanionBuilder,
      (SmsTemplateRow, $$SmsTemplatesTableReferences),
      SmsTemplateRow,
      PrefetchHooks Function({bool bankId})
    >;
typedef $$RawSmsTableCreateCompanionBuilder = RawSmsCompanion Function({
  Value<int> id,
  required String address,
  required String body,
  required DateTime receivedAt,
  required String hash,
  required SmsStatus status,
  Value<String?> templateCode,
});
typedef $$RawSmsTableUpdateCompanionBuilder = RawSmsCompanion Function({
  Value<int> id,
  Value<String> address,
  Value<String> body,
  Value<DateTime> receivedAt,
  Value<String> hash,
  Value<SmsStatus> status,
  Value<String?> templateCode,
});

final class $$RawSmsTableReferences
    extends BaseReferences<_$AppDb, $RawSmsTable, RawSmsRow> {
  $$RawSmsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'raw_sms__id__transactions__raw_sms_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.rawSmsId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RawSmsTableFilterComposer extends Composer<_$AppDb, $RawSmsTable> {
  $$RawSmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SmsStatus, SmsStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get templateCode => $composableBuilder(
    column: $table.templateCode,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.rawSmsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RawSmsTableOrderingComposer extends Composer<_$AppDb, $RawSmsTable> {
  $$RawSmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateCode => $composableBuilder(
    column: $table.templateCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RawSmsTableAnnotationComposer extends Composer<_$AppDb, $RawSmsTable> {
  $$RawSmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SmsStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get templateCode => $composableBuilder(
    column: $table.templateCode,
    builder: (column) => column,
  );

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.rawSmsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RawSmsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $RawSmsTable,
          RawSmsRow,
          $$RawSmsTableFilterComposer,
          $$RawSmsTableOrderingComposer,
          $$RawSmsTableAnnotationComposer,
          $$RawSmsTableCreateCompanionBuilder,
          $$RawSmsTableUpdateCompanionBuilder,
          (RawSmsRow, $$RawSmsTableReferences),
          RawSmsRow,
          PrefetchHooks Function({bool transactionsRefs})
        > {
  $$RawSmsTableTableManager(_$AppDb db, $RawSmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawSmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawSmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawSmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<SmsStatus> status = const Value.absent(),
                Value<String?> templateCode = const Value.absent(),
              }) => RawSmsCompanion(
                id: id,
                address: address,
                body: body,
                receivedAt: receivedAt,
                hash: hash,
                status: status,
                templateCode: templateCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String address,
                required String body,
                required DateTime receivedAt,
                required String hash,
                required SmsStatus status,
                Value<String?> templateCode = const Value.absent(),
              }) => RawSmsCompanion.insert(
                id: id,
                address: address,
                body: body,
                receivedAt: receivedAt,
                hash: hash,
                status: status,
                templateCode: templateCode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RawSmsTable, RawSmsRow>(table),
                  $$RawSmsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedDataByColumns<
                      RawSmsRow,
                      $RawSmsTable,
                      Transaction,
                      $TransactionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$RawSmsTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$RawSmsTableReferences(
                        db,
                        table,
                        p0,
                      ).transactionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'raw_sms_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RawSmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $RawSmsTable,
      RawSmsRow,
      $$RawSmsTableFilterComposer,
      $$RawSmsTableOrderingComposer,
      $$RawSmsTableAnnotationComposer,
      $$RawSmsTableCreateCompanionBuilder,
      $$RawSmsTableUpdateCompanionBuilder,
      (RawSmsRow, $$RawSmsTableReferences),
      RawSmsRow,
      PrefetchHooks Function({bool transactionsRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<int?> parentId,
  required CategoryKind kind,
  required String name,
  Value<String?> nameKey,
  required String icon,
  required int color,
  Value<bool> builtin,
  Value<bool> archived,
  Value<int> sort,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<int?> parentId,
  Value<CategoryKind> kind,
  Value<String> name,
  Value<String?> nameKey,
  Value<String> icon,
  Value<int> color,
  Value<bool> builtin,
  Value<bool> archived,
  Value<int> sort,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDb, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDb db) =>
      db.categories.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'categories__id__budgets__category_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurringsTable, List<Recurring>>
  _recurringsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.recurrings,
    aliasName: 'categories__id__recurrings__category_id',
  );

  $$RecurringsTableProcessedTableManager get recurringsRefs {
    final manager = $$RecurringsTableTableManager(
      $_db,
      $_db.recurrings,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurringsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDb, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoryKind, CategoryKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringsRefs(
    Expression<bool> Function($$RecurringsTableFilterComposer f) f,
  ) {
    final $$RecurringsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrings,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringsTableFilterComposer(
            $db: $db,
            $table: $db.recurrings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDb, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDb, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get sort =>
      $composableBuilder(column: $table.sort, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringsRefs<T extends Object>(
    Expression<T> Function($$RecurringsTableAnnotationComposer a) f,
  ) {
    final $$RecurringsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrings,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringsTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool parentId,
            bool transactionsRefs,
            bool budgetsRefs,
            bool recurringsRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDb db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<CategoryKind> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameKey = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                parentId: parentId,
                kind: kind,
                name: name,
                nameKey: nameKey,
                icon: icon,
                color: color,
                builtin: builtin,
                archived: archived,
                sort: sort,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                required CategoryKind kind,
                required String name,
                Value<String?> nameKey = const Value.absent(),
                required String icon,
                required int color,
                Value<bool> builtin = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                parentId: parentId,
                kind: kind,
                name: name,
                nameKey: nameKey,
                icon: icon,
                color: color,
                builtin: builtin,
                archived: archived,
                sort: sort,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                transactionsRefs = false,
                budgetsRefs = false,
                recurringsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (budgetsRefs) db.budgets,
                    if (recurringsRefs) db.recurrings,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$CategoriesTableReferences
                                ._parentIdTable(db),
                            referencedColumn: $$CategoriesTableReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          Transaction,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (budgetsRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          Budget,
                          $BudgetsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (recurringsRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          Recurring,
                          $RecurringsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._recurringsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool parentId,
        bool transactionsRefs,
        bool budgetsRefs,
        bool recurringsRefs,
      })
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> nameKey,
  required String icon,
  required int color,
  Value<bool> builtin,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> nameKey,
  Value<String> icon,
  Value<int> color,
  Value<bool> builtin,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDb, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTagsTable, List<TransactionTag>>
  _transactionTagsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.transactionTags,
    aliasName: 'tags__id__transaction_tags__tag_id',
  );

  $$TransactionTagsTableProcessedTableManager get transactionTagsRefs {
    final manager = $$TransactionTagsTableTableManager(
      $_db,
      $_db.transactionTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDb, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionTagsRefs(
    Expression<bool> Function($$TransactionTagsTableFilterComposer f) f,
  ) {
    final $$TransactionTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableFilterComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDb, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer extends Composer<_$AppDb, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  Expression<T> transactionTagsRefs<T extends Object>(
    Expression<T> Function($$TransactionTagsTableAnnotationComposer a) f,
  ) {
    final $$TransactionTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool transactionTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDb db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameKey = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                nameKey: nameKey,
                icon: icon,
                color: color,
                builtin: builtin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nameKey = const Value.absent(),
                required String icon,
                required int color,
                Value<bool> builtin = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                nameKey: nameKey,
                icon: icon,
                color: color,
                builtin: builtin,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTagsRefs) db.transactionTags,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTagsRefs)
                    await $_getPrefetchedDataByColumns<
                      Tag,
                      $TagsTable,
                      TransactionTag,
                      $TransactionTagsTable
                    >(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._transactionTagsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TagsTableReferences(
                        db,
                        table,
                        p0,
                      ).transactionTagsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'tag_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool transactionTagsRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int accountId,
      required int amount,
      required DateTime occurredAt,
      required int jalaliYm,
      Value<int?> balanceAfter,
      required TxKind kind,
      Value<int?> categoryId,
      Value<String> note,
      Value<bool> marked,
      Value<bool> excluded,
      Value<bool> needsReview,
      required TxSource source,
      Value<int?> rawSmsId,
      Value<int?> transferGroupId,
      Value<int?> recurringId,
      Value<int?> balanceGap,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<int> amount,
      Value<DateTime> occurredAt,
      Value<int> jalaliYm,
      Value<int?> balanceAfter,
      Value<TxKind> kind,
      Value<int?> categoryId,
      Value<String> note,
      Value<bool> marked,
      Value<bool> excluded,
      Value<bool> needsReview,
      Value<TxSource> source,
      Value<int?> rawSmsId,
      Value<int?> transferGroupId,
      Value<int?> recurringId,
      Value<int?> balanceGap,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDb, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDb db) =>
      db.accounts.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDb db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RawSmsTable _rawSmsIdTable(_$AppDb db) =>
      db.rawSms.createAlias('transactions__raw_sms_id__raw_sms__id');

  $$RawSmsTableProcessedTableManager? get rawSmsId {
    final $_column = $_itemColumn<int>('raw_sms_id');
    if ($_column == null) return null;
    final manager = $$RawSmsTableTableManager(
      $_db,
      $_db.rawSms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rawSmsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionTagsTable, List<TransactionTag>>
  _transactionTagsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.transactionTags,
    aliasName: 'transactions__id__transaction_tags__transaction_id',
  );

  $$TransactionTagsTableProcessedTableManager get transactionTagsRefs {
    final manager = $$TransactionTagsTableTableManager(
      $_db,
      $_db.transactionTags,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SplitsTable, List<SplitRow>> _splitsRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.splits,
    aliasName: 'transactions__id__splits__transaction_id',
  );

  $$SplitsTableProcessedTableManager get splitsRefs {
    final manager = $$SplitsTableTableManager(
      $_db,
      $_db.splits,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_splitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SettlementsTable, List<Settlement>>
  _settlementsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.settlements,
    aliasName: 'transactions__id__settlements__transaction_id',
  );

  $$SettlementsTableProcessedTableManager get settlementsRefs {
    final manager = $$SettlementsTableTableManager(
      $_db,
      $_db.settlements,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_settlementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDb, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jalaliYm => $composableBuilder(
    column: $table.jalaliYm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxKind, TxKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get marked => $composableBuilder(
    column: $table.marked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get excluded => $composableBuilder(
    column: $table.excluded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsReview => $composableBuilder(
    column: $table.needsReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxSource, TxSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceGap => $composableBuilder(
    column: $table.balanceGap,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RawSmsTableFilterComposer get rawSmsId {
    final $$RawSmsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rawSmsId,
      referencedTable: $db.rawSms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RawSmsTableFilterComposer(
            $db: $db,
            $table: $db.rawSms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionTagsRefs(
    Expression<bool> Function($$TransactionTagsTableFilterComposer f) f,
  ) {
    final $$TransactionTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableFilterComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> splitsRefs(
    Expression<bool> Function($$SplitsTableFilterComposer f) f,
  ) {
    final $$SplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splits,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitsTableFilterComposer(
            $db: $db,
            $table: $db.splits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> settlementsRefs(
    Expression<bool> Function($$SettlementsTableFilterComposer f) f,
  ) {
    final $$SettlementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableFilterComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDb, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jalaliYm => $composableBuilder(
    column: $table.jalaliYm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get marked => $composableBuilder(
    column: $table.marked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get excluded => $composableBuilder(
    column: $table.excluded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsReview => $composableBuilder(
    column: $table.needsReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceGap => $composableBuilder(
    column: $table.balanceGap,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RawSmsTableOrderingComposer get rawSmsId {
    final $$RawSmsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rawSmsId,
      referencedTable: $db.rawSms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RawSmsTableOrderingComposer(
            $db: $db,
            $table: $db.rawSms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDb, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get jalaliYm =>
      $composableBuilder(column: $table.jalaliYm, builder: (column) => column);

  GeneratedColumn<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TxKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get marked =>
      $composableBuilder(column: $table.marked, builder: (column) => column);

  GeneratedColumn<bool> get excluded =>
      $composableBuilder(column: $table.excluded, builder: (column) => column);

  GeneratedColumn<bool> get needsReview => $composableBuilder(
    column: $table.needsReview,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TxSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balanceGap => $composableBuilder(
    column: $table.balanceGap,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RawSmsTableAnnotationComposer get rawSmsId {
    final $$RawSmsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rawSmsId,
      referencedTable: $db.rawSms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RawSmsTableAnnotationComposer(
            $db: $db,
            $table: $db.rawSms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionTagsRefs<T extends Object>(
    Expression<T> Function($$TransactionTagsTableAnnotationComposer a) f,
  ) {
    final $$TransactionTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> splitsRefs<T extends Object>(
    Expression<T> Function($$SplitsTableAnnotationComposer a) f,
  ) {
    final $$SplitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splits,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitsTableAnnotationComposer(
            $db: $db,
            $table: $db.splits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> settlementsRefs<T extends Object>(
    Expression<T> Function($$SettlementsTableAnnotationComposer a) f,
  ) {
    final $$SettlementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableAnnotationComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool accountId,
            bool categoryId,
            bool rawSmsId,
            bool transactionTagsRefs,
            bool splitsRefs,
            bool settlementsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDb db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> jalaliYm = const Value.absent(),
                Value<int?> balanceAfter = const Value.absent(),
                Value<TxKind> kind = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> marked = const Value.absent(),
                Value<bool> excluded = const Value.absent(),
                Value<bool> needsReview = const Value.absent(),
                Value<TxSource> source = const Value.absent(),
                Value<int?> rawSmsId = const Value.absent(),
                Value<int?> transferGroupId = const Value.absent(),
                Value<int?> recurringId = const Value.absent(),
                Value<int?> balanceGap = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                accountId: accountId,
                amount: amount,
                occurredAt: occurredAt,
                jalaliYm: jalaliYm,
                balanceAfter: balanceAfter,
                kind: kind,
                categoryId: categoryId,
                note: note,
                marked: marked,
                excluded: excluded,
                needsReview: needsReview,
                source: source,
                rawSmsId: rawSmsId,
                transferGroupId: transferGroupId,
                recurringId: recurringId,
                balanceGap: balanceGap,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required int amount,
                required DateTime occurredAt,
                required int jalaliYm,
                Value<int?> balanceAfter = const Value.absent(),
                required TxKind kind,
                Value<int?> categoryId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> marked = const Value.absent(),
                Value<bool> excluded = const Value.absent(),
                Value<bool> needsReview = const Value.absent(),
                required TxSource source,
                Value<int?> rawSmsId = const Value.absent(),
                Value<int?> transferGroupId = const Value.absent(),
                Value<int?> recurringId = const Value.absent(),
                Value<int?> balanceGap = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                accountId: accountId,
                amount: amount,
                occurredAt: occurredAt,
                jalaliYm: jalaliYm,
                balanceAfter: balanceAfter,
                kind: kind,
                categoryId: categoryId,
                note: note,
                marked: marked,
                excluded: excluded,
                needsReview: needsReview,
                source: source,
                rawSmsId: rawSmsId,
                transferGroupId: transferGroupId,
                recurringId: recurringId,
                balanceGap: balanceGap,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, Transaction>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                categoryId = false,
                rawSmsId = false,
                transactionTagsRefs = false,
                splitsRefs = false,
                settlementsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionTagsRefs) db.transactionTags,
                    if (splitsRefs) db.splits,
                    if (settlementsRefs) db.settlements,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$TransactionsTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (rawSmsId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.rawSmsId,
                            referencedTable: $$TransactionsTableReferences
                                ._rawSmsIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._rawSmsIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionTagsRefs)
                        await $_getPrefetchedDataByColumns<
                          Transaction,
                          $TransactionsTable,
                          TransactionTag,
                          $TransactionTagsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._transactionTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionTagsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                      if (splitsRefs)
                        await $_getPrefetchedDataByColumns<
                          Transaction,
                          $TransactionsTable,
                          SplitRow,
                          $SplitsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._splitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).splitsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                      if (settlementsRefs)
                        await $_getPrefetchedDataByColumns<
                          Transaction,
                          $TransactionsTable,
                          Settlement,
                          $SettlementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._settlementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).settlementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool accountId,
        bool categoryId,
        bool rawSmsId,
        bool transactionTagsRefs,
        bool splitsRefs,
        bool settlementsRefs,
      })
    >;
typedef $$TransactionTagsTableCreateCompanionBuilder =
    TransactionTagsCompanion Function({
      required int transactionId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$TransactionTagsTableUpdateCompanionBuilder =
    TransactionTagsCompanion Function({
      Value<int> transactionId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$TransactionTagsTableReferences
    extends BaseReferences<_$AppDb, $TransactionTagsTable, TransactionTag> {
  $$TransactionTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDb db) => db.transactions
      .createAlias('transaction_tags__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDb db) =>
      db.tags.createAlias('transaction_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionTagsTableFilterComposer
    extends Composer<_$AppDb, $TransactionTagsTable> {
  $$TransactionTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTagsTableOrderingComposer
    extends Composer<_$AppDb, $TransactionTagsTable> {
  $$TransactionTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTagsTableAnnotationComposer
    extends Composer<_$AppDb, $TransactionTagsTable> {
  $$TransactionTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTagsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TransactionTagsTable,
          TransactionTag,
          $$TransactionTagsTableFilterComposer,
          $$TransactionTagsTableOrderingComposer,
          $$TransactionTagsTableAnnotationComposer,
          $$TransactionTagsTableCreateCompanionBuilder,
          $$TransactionTagsTableUpdateCompanionBuilder,
          (TransactionTag, $$TransactionTagsTableReferences),
          TransactionTag,
          PrefetchHooks Function({bool transactionId, bool tagId})
        > {
  $$TransactionTagsTableTableManager(_$AppDb db, $TransactionTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> transactionId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionTagsCompanion(
                transactionId: transactionId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int transactionId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => TransactionTagsCompanion.insert(
                transactionId: transactionId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionTagsTable, TransactionTag>(table),
                  $$TransactionTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transactionId,
                        referencedTable: $$TransactionTagsTableReferences
                            ._transactionIdTable(db),
                        referencedColumn: $$TransactionTagsTableReferences
                            ._transactionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$TransactionTagsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$TransactionTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TransactionTagsTable,
      TransactionTag,
      $$TransactionTagsTableFilterComposer,
      $$TransactionTagsTableOrderingComposer,
      $$TransactionTagsTableAnnotationComposer,
      $$TransactionTagsTableCreateCompanionBuilder,
      $$TransactionTagsTableUpdateCompanionBuilder,
      (TransactionTag, $$TransactionTagsTableReferences),
      TransactionTag,
      PrefetchHooks Function({bool transactionId, bool tagId})
    >;
typedef $$PeopleTableCreateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  required String icon,
  required int color,
  Value<String> note,
});
typedef $$PeopleTableUpdateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String> icon,
  Value<int> color,
  Value<String> note,
});

final class $$PeopleTableReferences
    extends BaseReferences<_$AppDb, $PeopleTable, Person> {
  $$PeopleTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SplitsTable, List<SplitRow>> _splitsRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.splits,
    aliasName: 'people__id__splits__person_id',
  );

  $$SplitsTableProcessedTableManager get splitsRefs {
    final manager = $$SplitsTableTableManager(
      $_db,
      $_db.splits,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_splitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SettlementsTable, List<Settlement>>
  _settlementsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.settlements,
    aliasName: 'people__id__settlements__person_id',
  );

  $$SettlementsTableProcessedTableManager get settlementsRefs {
    final manager = $$SettlementsTableTableManager(
      $_db,
      $_db.settlements,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_settlementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PeopleTableFilterComposer extends Composer<_$AppDb, $PeopleTable> {
  $$PeopleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> splitsRefs(
    Expression<bool> Function($$SplitsTableFilterComposer f) f,
  ) {
    final $$SplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splits,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitsTableFilterComposer(
            $db: $db,
            $table: $db.splits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> settlementsRefs(
    Expression<bool> Function($$SettlementsTableFilterComposer f) f,
  ) {
    final $$SettlementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableFilterComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeopleTableOrderingComposer extends Composer<_$AppDb, $PeopleTable> {
  $$PeopleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeopleTableAnnotationComposer extends Composer<_$AppDb, $PeopleTable> {
  $$PeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  Expression<T> splitsRefs<T extends Object>(
    Expression<T> Function($$SplitsTableAnnotationComposer a) f,
  ) {
    final $$SplitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splits,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitsTableAnnotationComposer(
            $db: $db,
            $table: $db.splits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> settlementsRefs<T extends Object>(
    Expression<T> Function($$SettlementsTableAnnotationComposer a) f,
  ) {
    final $$SettlementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableAnnotationComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeopleTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $PeopleTable,
          Person,
          $$PeopleTableFilterComposer,
          $$PeopleTableOrderingComposer,
          $$PeopleTableAnnotationComposer,
          $$PeopleTableCreateCompanionBuilder,
          $$PeopleTableUpdateCompanionBuilder,
          (Person, $$PeopleTableReferences),
          Person,
          PrefetchHooks Function({bool splitsRefs, bool settlementsRefs})
        > {
  $$PeopleTableTableManager(_$AppDb db, $PeopleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => PeopleCompanion(
                id: id,
                name: name,
                phone: phone,
                icon: icon,
                color: color,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                required String icon,
                required int color,
                Value<String> note = const Value.absent(),
              }) => PeopleCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                icon: icon,
                color: color,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PeopleTable, Person>(table),
                  $$PeopleTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({splitsRefs = false, settlementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (splitsRefs) db.splits,
                    if (settlementsRefs) db.settlements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (splitsRefs)
                        await $_getPrefetchedDataByColumns<
                          Person,
                          $PeopleTable,
                          SplitRow,
                          $SplitsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PeopleTableReferences
                              ._splitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeopleTableReferences(db, table, p0).splitsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'person_id',
                          typedResults: items,
                        ),
                      if (settlementsRefs)
                        await $_getPrefetchedDataByColumns<
                          Person,
                          $PeopleTable,
                          Settlement,
                          $SettlementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PeopleTableReferences
                              ._settlementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeopleTableReferences(
                                db,
                                table,
                                p0,
                              ).settlementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'person_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PeopleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $PeopleTable,
      Person,
      $$PeopleTableFilterComposer,
      $$PeopleTableOrderingComposer,
      $$PeopleTableAnnotationComposer,
      $$PeopleTableCreateCompanionBuilder,
      $$PeopleTableUpdateCompanionBuilder,
      (Person, $$PeopleTableReferences),
      Person,
      PrefetchHooks Function({bool splitsRefs, bool settlementsRefs})
    >;
typedef $$SplitsTableCreateCompanionBuilder = SplitsCompanion Function({
  Value<int> id,
  Value<int?> transactionId,
  required int personId,
  required int share,
  Value<String> note,
  required DateTime occurredAt,
});
typedef $$SplitsTableUpdateCompanionBuilder = SplitsCompanion Function({
  Value<int> id,
  Value<int?> transactionId,
  Value<int> personId,
  Value<int> share,
  Value<String> note,
  Value<DateTime> occurredAt,
});

final class $$SplitsTableReferences
    extends BaseReferences<_$AppDb, $SplitsTable, SplitRow> {
  $$SplitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _transactionIdTable(_$AppDb db) =>
      db.transactions.createAlias('splits__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeopleTable _personIdTable(_$AppDb db) =>
      db.people.createAlias('splits__person_id__people__id');

  $$PeopleTableProcessedTableManager get personId {
    final $_column = $_itemColumn<int>('person_id')!;

    final manager = $$PeopleTableTableManager(
      $_db,
      $_db.people,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SplitsTableFilterComposer extends Composer<_$AppDb, $SplitsTable> {
  $$SplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get share => $composableBuilder(
    column: $table.share,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeopleTableFilterComposer get personId {
    final $$PeopleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableFilterComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitsTableOrderingComposer extends Composer<_$AppDb, $SplitsTable> {
  $$SplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get share => $composableBuilder(
    column: $table.share,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeopleTableOrderingComposer get personId {
    final $$PeopleTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableOrderingComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitsTableAnnotationComposer extends Composer<_$AppDb, $SplitsTable> {
  $$SplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get share =>
      $composableBuilder(column: $table.share, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeopleTableAnnotationComposer get personId {
    final $$PeopleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableAnnotationComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SplitsTable,
          SplitRow,
          $$SplitsTableFilterComposer,
          $$SplitsTableOrderingComposer,
          $$SplitsTableAnnotationComposer,
          $$SplitsTableCreateCompanionBuilder,
          $$SplitsTableUpdateCompanionBuilder,
          (SplitRow, $$SplitsTableReferences),
          SplitRow,
          PrefetchHooks Function({bool transactionId, bool personId})
        > {
  $$SplitsTableTableManager(_$AppDb db, $SplitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<int> personId = const Value.absent(),
                Value<int> share = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
              }) => SplitsCompanion(
                id: id,
                transactionId: transactionId,
                personId: personId,
                share: share,
                note: note,
                occurredAt: occurredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                required int personId,
                required int share,
                Value<String> note = const Value.absent(),
                required DateTime occurredAt,
              }) => SplitsCompanion.insert(
                id: id,
                transactionId: transactionId,
                personId: personId,
                share: share,
                note: note,
                occurredAt: occurredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SplitsTable, SplitRow>(table),
                  $$SplitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false, personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transactionId,
                        referencedTable: $$SplitsTableReferences
                            ._transactionIdTable(db),
                        referencedColumn: $$SplitsTableReferences
                            ._transactionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$SplitsTableReferences._personIdTable(
                          db,
                        ),
                        referencedColumn: $$SplitsTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SplitsTable,
      SplitRow,
      $$SplitsTableFilterComposer,
      $$SplitsTableOrderingComposer,
      $$SplitsTableAnnotationComposer,
      $$SplitsTableCreateCompanionBuilder,
      $$SplitsTableUpdateCompanionBuilder,
      (SplitRow, $$SplitsTableReferences),
      SplitRow,
      PrefetchHooks Function({bool transactionId, bool personId})
    >;
typedef $$SettlementsTableCreateCompanionBuilder =
    SettlementsCompanion Function({
      Value<int> id,
      required int personId,
      required int amount,
      required DateTime occurredAt,
      Value<String> note,
      Value<int?> transactionId,
    });
typedef $$SettlementsTableUpdateCompanionBuilder =
    SettlementsCompanion Function({
      Value<int> id,
      Value<int> personId,
      Value<int> amount,
      Value<DateTime> occurredAt,
      Value<String> note,
      Value<int?> transactionId,
    });

final class $$SettlementsTableReferences
    extends BaseReferences<_$AppDb, $SettlementsTable, Settlement> {
  $$SettlementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PeopleTable _personIdTable(_$AppDb db) =>
      db.people.createAlias('settlements__person_id__people__id');

  $$PeopleTableProcessedTableManager get personId {
    final $_column = $_itemColumn<int>('person_id')!;

    final manager = $$PeopleTableTableManager(
      $_db,
      $_db.people,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDb db) => db.transactions
      .createAlias('settlements__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SettlementsTableFilterComposer
    extends Composer<_$AppDb, $SettlementsTable> {
  $$SettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PeopleTableFilterComposer get personId {
    final $$PeopleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableFilterComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettlementsTableOrderingComposer
    extends Composer<_$AppDb, $SettlementsTable> {
  $$SettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PeopleTableOrderingComposer get personId {
    final $$PeopleTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableOrderingComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettlementsTableAnnotationComposer
    extends Composer<_$AppDb, $SettlementsTable> {
  $$SettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PeopleTableAnnotationComposer get personId {
    final $$PeopleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableAnnotationComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettlementsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SettlementsTable,
          Settlement,
          $$SettlementsTableFilterComposer,
          $$SettlementsTableOrderingComposer,
          $$SettlementsTableAnnotationComposer,
          $$SettlementsTableCreateCompanionBuilder,
          $$SettlementsTableUpdateCompanionBuilder,
          (Settlement, $$SettlementsTableReferences),
          Settlement,
          PrefetchHooks Function({bool personId, bool transactionId})
        > {
  $$SettlementsTableTableManager(_$AppDb db, $SettlementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
              }) => SettlementsCompanion(
                id: id,
                personId: personId,
                amount: amount,
                occurredAt: occurredAt,
                note: note,
                transactionId: transactionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personId,
                required int amount,
                required DateTime occurredAt,
                Value<String> note = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
              }) => SettlementsCompanion.insert(
                id: id,
                personId: personId,
                amount: amount,
                occurredAt: occurredAt,
                note: note,
                transactionId: transactionId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettlementsTable, Settlement>(table),
                  $$SettlementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personId = false, transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$SettlementsTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$SettlementsTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (transactionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transactionId,
                        referencedTable: $$SettlementsTableReferences
                            ._transactionIdTable(db),
                        referencedColumn: $$SettlementsTableReferences
                            ._transactionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SettlementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SettlementsTable,
      Settlement,
      $$SettlementsTableFilterComposer,
      $$SettlementsTableOrderingComposer,
      $$SettlementsTableAnnotationComposer,
      $$SettlementsTableCreateCompanionBuilder,
      $$SettlementsTableUpdateCompanionBuilder,
      (Settlement, $$SettlementsTableReferences),
      Settlement,
      PrefetchHooks Function({bool personId, bool transactionId})
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  required int categoryId,
  required int monthlyLimit,
  required int fromYm,
  Value<int?> toYm,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<int> monthlyLimit,
  Value<int> fromYm,
  Value<int?> toYm,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDb, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDb db) =>
      db.categories.createAlias('budgets__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableFilterComposer extends Composer<_$AppDb, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyLimit => $composableBuilder(
    column: $table.monthlyLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromYm => $composableBuilder(
    column: $table.fromYm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toYm => $composableBuilder(
    column: $table.toYm,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableOrderingComposer extends Composer<_$AppDb, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyLimit => $composableBuilder(
    column: $table.monthlyLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromYm => $composableBuilder(
    column: $table.fromYm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toYm => $composableBuilder(
    column: $table.toYm,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDb, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get monthlyLimit => $composableBuilder(
    column: $table.monthlyLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fromYm =>
      $composableBuilder(column: $table.fromYm, builder: (column) => column);

  GeneratedColumn<int> get toYm =>
      $composableBuilder(column: $table.toYm, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, $$BudgetsTableReferences),
          Budget,
          PrefetchHooks Function({bool categoryId})
        > {
  $$BudgetsTableTableManager(_$AppDb db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> monthlyLimit = const Value.absent(),
                Value<int> fromYm = const Value.absent(),
                Value<int?> toYm = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoryId: categoryId,
                monthlyLimit: monthlyLimit,
                fromYm: fromYm,
                toYm: toYm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                required int monthlyLimit,
                required int fromYm,
                Value<int?> toYm = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoryId: categoryId,
                monthlyLimit: monthlyLimit,
                fromYm: fromYm,
                toYm: toYm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, Budget>(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$BudgetsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$BudgetsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, $$BudgetsTableReferences),
      Budget,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$RecurringsTableCreateCompanionBuilder = RecurringsCompanion Function({
  Value<int> id,
  required int accountId,
  required int expectedAmount,
  required int periodDays,
  required DateTime nextDue,
  Value<int?> categoryId,
  Value<bool> confirmed,
  Value<bool> dismissed,
});
typedef $$RecurringsTableUpdateCompanionBuilder = RecurringsCompanion Function({
  Value<int> id,
  Value<int> accountId,
  Value<int> expectedAmount,
  Value<int> periodDays,
  Value<DateTime> nextDue,
  Value<int?> categoryId,
  Value<bool> confirmed,
  Value<bool> dismissed,
});

final class $$RecurringsTableReferences
    extends BaseReferences<_$AppDb, $RecurringsTable, Recurring> {
  $$RecurringsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDb db) =>
      db.accounts.createAlias('recurrings__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDb db) =>
      db.categories.createAlias('recurrings__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurringsTableFilterComposer
    extends Composer<_$AppDb, $RecurringsTable> {
  $$RecurringsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodDays => $composableBuilder(
    column: $table.periodDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringsTableOrderingComposer
    extends Composer<_$AppDb, $RecurringsTable> {
  $$RecurringsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodDays => $composableBuilder(
    column: $table.periodDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringsTableAnnotationComposer
    extends Composer<_$AppDb, $RecurringsTable> {
  $$RecurringsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodDays => $composableBuilder(
    column: $table.periodDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextDue =>
      $composableBuilder(column: $table.nextDue, builder: (column) => column);

  GeneratedColumn<bool> get confirmed =>
      $composableBuilder(column: $table.confirmed, builder: (column) => column);

  GeneratedColumn<bool> get dismissed =>
      $composableBuilder(column: $table.dismissed, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $RecurringsTable,
          Recurring,
          $$RecurringsTableFilterComposer,
          $$RecurringsTableOrderingComposer,
          $$RecurringsTableAnnotationComposer,
          $$RecurringsTableCreateCompanionBuilder,
          $$RecurringsTableUpdateCompanionBuilder,
          (Recurring, $$RecurringsTableReferences),
          Recurring,
          PrefetchHooks Function({bool accountId, bool categoryId})
        > {
  $$RecurringsTableTableManager(_$AppDb db, $RecurringsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> expectedAmount = const Value.absent(),
                Value<int> periodDays = const Value.absent(),
                Value<DateTime> nextDue = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> confirmed = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
              }) => RecurringsCompanion(
                id: id,
                accountId: accountId,
                expectedAmount: expectedAmount,
                periodDays: periodDays,
                nextDue: nextDue,
                categoryId: categoryId,
                confirmed: confirmed,
                dismissed: dismissed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required int expectedAmount,
                required int periodDays,
                required DateTime nextDue,
                Value<int?> categoryId = const Value.absent(),
                Value<bool> confirmed = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
              }) => RecurringsCompanion.insert(
                id: id,
                accountId: accountId,
                expectedAmount: expectedAmount,
                periodDays: periodDays,
                nextDue: nextDue,
                categoryId: categoryId,
                confirmed: confirmed,
                dismissed: dismissed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurringsTable, Recurring>(table),
                  $$RecurringsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$RecurringsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$RecurringsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$RecurringsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$RecurringsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecurringsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $RecurringsTable,
      Recurring,
      $$RecurringsTableFilterComposer,
      $$RecurringsTableOrderingComposer,
      $$RecurringsTableAnnotationComposer,
      $$RecurringsTableCreateCompanionBuilder,
      $$RecurringsTableUpdateCompanionBuilder,
      (Recurring, $$RecurringsTableReferences),
      Recurring,
      PrefetchHooks Function({bool accountId, bool categoryId})
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required ReminderTarget targetType,
  required int targetId,
  required DateTime at,
  Value<String> body,
  Value<bool> done,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<ReminderTarget> targetType,
  Value<int> targetId,
  Value<DateTime> at,
  Value<String> body,
  Value<bool> done,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDb, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReminderTarget, ReminderTarget, String>
  get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDb, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDb, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReminderTarget, String> get targetType =>
      $composableBuilder(
        column: $table.targetType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDb, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDb db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ReminderTarget> targetType = const Value.absent(),
                Value<int> targetId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> done = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                targetType: targetType,
                targetId: targetId,
                at: at,
                body: body,
                done: done,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required ReminderTarget targetType,
                required int targetId,
                required DateTime at,
                Value<String> body = const Value.absent(),
                Value<bool> done = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                targetType: targetType,
                targetId: targetId,
                at: at,
                body: body,
                done: done,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  BaseReferences<_$AppDb, $RemindersTable, Reminder>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDb, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$InboxItemsTableCreateCompanionBuilder = InboxItemsCompanion Function({
  Value<int> id,
  required String kind,
  required String title,
  Value<String> body,
  Value<String?> payload,
  Value<DateTime> createdAt,
  Value<bool> read,
});
typedef $$InboxItemsTableUpdateCompanionBuilder = InboxItemsCompanion Function({
  Value<int> id,
  Value<String> kind,
  Value<String> title,
  Value<String> body,
  Value<String?> payload,
  Value<DateTime> createdAt,
  Value<bool> read,
});

class $$InboxItemsTableFilterComposer
    extends Composer<_$AppDb, $InboxItemsTable> {
  $$InboxItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InboxItemsTableOrderingComposer
    extends Composer<_$AppDb, $InboxItemsTable> {
  $$InboxItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InboxItemsTableAnnotationComposer
    extends Composer<_$AppDb, $InboxItemsTable> {
  $$InboxItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);
}

class $$InboxItemsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $InboxItemsTable,
          InboxItem,
          $$InboxItemsTableFilterComposer,
          $$InboxItemsTableOrderingComposer,
          $$InboxItemsTableAnnotationComposer,
          $$InboxItemsTableCreateCompanionBuilder,
          $$InboxItemsTableUpdateCompanionBuilder,
          (InboxItem, BaseReferences<_$AppDb, $InboxItemsTable, InboxItem>),
          InboxItem,
          PrefetchHooks Function()
        > {
  $$InboxItemsTableTableManager(_$AppDb db, $InboxItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InboxItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InboxItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InboxItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> read = const Value.absent(),
              }) => InboxItemsCompanion(
                id: id,
                kind: kind,
                title: title,
                body: body,
                payload: payload,
                createdAt: createdAt,
                read: read,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String title,
                Value<String> body = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> read = const Value.absent(),
              }) => InboxItemsCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                body: body,
                payload: payload,
                createdAt: createdAt,
                read: read,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InboxItemsTable, InboxItem>(table),
                  BaseReferences<_$AppDb, $InboxItemsTable, InboxItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InboxItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $InboxItemsTable,
      InboxItem,
      $$InboxItemsTableFilterComposer,
      $$InboxItemsTableOrderingComposer,
      $$InboxItemsTableAnnotationComposer,
      $$InboxItemsTableCreateCompanionBuilder,
      $$InboxItemsTableUpdateCompanionBuilder,
      (InboxItem, BaseReferences<_$AppDb, $InboxItemsTable, InboxItem>),
      InboxItem,
      PrefetchHooks Function()
    >;
typedef $$TransferProposalsTableCreateCompanionBuilder =
    TransferProposalsCompanion Function({
      Value<int> id,
      required int outTxId,
      required int inTxId,
      Value<String> status,
    });
typedef $$TransferProposalsTableUpdateCompanionBuilder =
    TransferProposalsCompanion Function({
      Value<int> id,
      Value<int> outTxId,
      Value<int> inTxId,
      Value<String> status,
    });

final class $$TransferProposalsTableReferences
    extends BaseReferences<_$AppDb, $TransferProposalsTable, TransferProposal> {
  $$TransferProposalsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _outTxIdTable(_$AppDb db) => db.transactions
      .createAlias('transfer_proposals__out_tx_id__transactions__id');

  $$TransactionsTableProcessedTableManager get outTxId {
    final $_column = $_itemColumn<int>('out_tx_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_outTxIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _inTxIdTable(_$AppDb db) => db.transactions
      .createAlias('transfer_proposals__in_tx_id__transactions__id');

  $$TransactionsTableProcessedTableManager get inTxId {
    final $_column = $_itemColumn<int>('in_tx_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inTxIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransferProposalsTableFilterComposer
    extends Composer<_$AppDb, $TransferProposalsTable> {
  $$TransferProposalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get outTxId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outTxId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get inTxId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inTxId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransferProposalsTableOrderingComposer
    extends Composer<_$AppDb, $TransferProposalsTable> {
  $$TransferProposalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get outTxId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outTxId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get inTxId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inTxId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransferProposalsTableAnnotationComposer
    extends Composer<_$AppDb, $TransferProposalsTable> {
  $$TransferProposalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get outTxId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.outTxId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get inTxId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inTxId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransferProposalsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TransferProposalsTable,
          TransferProposal,
          $$TransferProposalsTableFilterComposer,
          $$TransferProposalsTableOrderingComposer,
          $$TransferProposalsTableAnnotationComposer,
          $$TransferProposalsTableCreateCompanionBuilder,
          $$TransferProposalsTableUpdateCompanionBuilder,
          (TransferProposal, $$TransferProposalsTableReferences),
          TransferProposal,
          PrefetchHooks Function({bool outTxId, bool inTxId})
        > {
  $$TransferProposalsTableTableManager(
    _$AppDb db,
    $TransferProposalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransferProposalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransferProposalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransferProposalsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> outTxId = const Value.absent(),
                Value<int> inTxId = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => TransferProposalsCompanion(
                id: id,
                outTxId: outTxId,
                inTxId: inTxId,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int outTxId,
                required int inTxId,
                Value<String> status = const Value.absent(),
              }) => TransferProposalsCompanion.insert(
                id: id,
                outTxId: outTxId,
                inTxId: inTxId,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransferProposalsTable, TransferProposal>(table),
                  $$TransferProposalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({outTxId = false, inTxId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (outTxId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.outTxId,
                        referencedTable: $$TransferProposalsTableReferences
                            ._outTxIdTable(db),
                        referencedColumn: $$TransferProposalsTableReferences
                            ._outTxIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (inTxId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.inTxId,
                        referencedTable: $$TransferProposalsTableReferences
                            ._inTxIdTable(db),
                        referencedColumn: $$TransferProposalsTableReferences
                            ._inTxIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransferProposalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TransferProposalsTable,
      TransferProposal,
      $$TransferProposalsTableFilterComposer,
      $$TransferProposalsTableOrderingComposer,
      $$TransferProposalsTableAnnotationComposer,
      $$TransferProposalsTableCreateCompanionBuilder,
      $$TransferProposalsTableUpdateCompanionBuilder,
      (TransferProposal, $$TransferProposalsTableReferences),
      TransferProposal,
      PrefetchHooks Function({bool outTxId, bool inTxId})
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer extends Composer<_$AppDb, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDb, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDb, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDb, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDb db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDb, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDb, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$BanksTableTableManager get banks =>
      $$BanksTableTableManager(_db, _db.banks);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$SmsSendersTableTableManager get smsSenders =>
      $$SmsSendersTableTableManager(_db, _db.smsSenders);
  $$SmsTemplatesTableTableManager get smsTemplates =>
      $$SmsTemplatesTableTableManager(_db, _db.smsTemplates);
  $$RawSmsTableTableManager get rawSms =>
      $$RawSmsTableTableManager(_db, _db.rawSms);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionTagsTableTableManager get transactionTags =>
      $$TransactionTagsTableTableManager(_db, _db.transactionTags);
  $$PeopleTableTableManager get people =>
      $$PeopleTableTableManager(_db, _db.people);
  $$SplitsTableTableManager get splits =>
      $$SplitsTableTableManager(_db, _db.splits);
  $$SettlementsTableTableManager get settlements =>
      $$SettlementsTableTableManager(_db, _db.settlements);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$RecurringsTableTableManager get recurrings =>
      $$RecurringsTableTableManager(_db, _db.recurrings);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$InboxItemsTableTableManager get inboxItems =>
      $$InboxItemsTableTableManager(_db, _db.inboxItems);
  $$TransferProposalsTableTableManager get transferProposals =>
      $$TransferProposalsTableTableManager(_db, _db.transferProposals);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
