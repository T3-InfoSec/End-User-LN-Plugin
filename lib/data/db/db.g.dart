// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $TlpDatasTable extends TlpDatas with TableInfo<$TlpDatasTable, TlpData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TlpDatasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mkeyMeta = const VerificationMeta('mkey');
  @override
  late final GeneratedColumn<String> mkey = GeneratedColumn<String>(
      'mkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mDataMeta = const VerificationMeta('mData');
  @override
  late final GeneratedColumn<String> mData = GeneratedColumn<String>(
      'm_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, mkey, mData, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tlp_datas';
  @override
  VerificationContext validateIntegrity(Insertable<TlpData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mkey')) {
      context.handle(
          _mkeyMeta, mkey.isAcceptableOrUnknown(data['mkey']!, _mkeyMeta));
    } else if (isInserting) {
      context.missing(_mkeyMeta);
    }
    if (data.containsKey('m_data')) {
      context.handle(
          _mDataMeta, mData.isAcceptableOrUnknown(data['m_data']!, _mDataMeta));
    } else if (isInserting) {
      context.missing(_mDataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TlpData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TlpData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mkey'])!,
      mData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}m_data'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $TlpDatasTable createAlias(String alias) {
    return $TlpDatasTable(attachedDatabase, alias);
  }
}

class TlpData extends DataClass implements Insertable<TlpData> {
  final int id;
  final String mkey;
  final String mData;
  final DateTime? createdAt;
  const TlpData(
      {required this.id,
      required this.mkey,
      required this.mData,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mkey'] = Variable<String>(mkey);
    map['m_data'] = Variable<String>(mData);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  TlpDatasCompanion toCompanion(bool nullToAbsent) {
    return TlpDatasCompanion(
      id: Value(id),
      mkey: Value(mkey),
      mData: Value(mData),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory TlpData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TlpData(
      id: serializer.fromJson<int>(json['id']),
      mkey: serializer.fromJson<String>(json['mkey']),
      mData: serializer.fromJson<String>(json['mData']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mkey': serializer.toJson<String>(mkey),
      'mData': serializer.toJson<String>(mData),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  TlpData copyWith(
          {int? id,
          String? mkey,
          String? mData,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      TlpData(
        id: id ?? this.id,
        mkey: mkey ?? this.mkey,
        mData: mData ?? this.mData,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  TlpData copyWithCompanion(TlpDatasCompanion data) {
    return TlpData(
      id: data.id.present ? data.id.value : this.id,
      mkey: data.mkey.present ? data.mkey.value : this.mkey,
      mData: data.mData.present ? data.mData.value : this.mData,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TlpData(')
          ..write('id: $id, ')
          ..write('mkey: $mkey, ')
          ..write('mData: $mData, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mkey, mData, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TlpData &&
          other.id == this.id &&
          other.mkey == this.mkey &&
          other.mData == this.mData &&
          other.createdAt == this.createdAt);
}

class TlpDatasCompanion extends UpdateCompanion<TlpData> {
  final Value<int> id;
  final Value<String> mkey;
  final Value<String> mData;
  final Value<DateTime?> createdAt;
  const TlpDatasCompanion({
    this.id = const Value.absent(),
    this.mkey = const Value.absent(),
    this.mData = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TlpDatasCompanion.insert({
    this.id = const Value.absent(),
    required String mkey,
    required String mData,
    this.createdAt = const Value.absent(),
  })  : mkey = Value(mkey),
        mData = Value(mData);
  static Insertable<TlpData> custom({
    Expression<int>? id,
    Expression<String>? mkey,
    Expression<String>? mData,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mkey != null) 'mkey': mkey,
      if (mData != null) 'm_data': mData,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TlpDatasCompanion copyWith(
      {Value<int>? id,
      Value<String>? mkey,
      Value<String>? mData,
      Value<DateTime?>? createdAt}) {
    return TlpDatasCompanion(
      id: id ?? this.id,
      mkey: mkey ?? this.mkey,
      mData: mData ?? this.mData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mkey.present) {
      map['mkey'] = Variable<String>(mkey.value);
    }
    if (mData.present) {
      map['m_data'] = Variable<String>(mData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TlpDatasCompanion(')
          ..write('id: $id, ')
          ..write('mkey: $mkey, ')
          ..write('mData: $mData, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TlpDatasTable tlpDatas = $TlpDatasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tlpDatas];
}

typedef $$TlpDatasTableCreateCompanionBuilder = TlpDatasCompanion Function({
  Value<int> id,
  required String mkey,
  required String mData,
  Value<DateTime?> createdAt,
});
typedef $$TlpDatasTableUpdateCompanionBuilder = TlpDatasCompanion Function({
  Value<int> id,
  Value<String> mkey,
  Value<String> mData,
  Value<DateTime?> createdAt,
});

class $$TlpDatasTableFilterComposer
    extends Composer<_$AppDatabase, $TlpDatasTable> {
  $$TlpDatasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mkey => $composableBuilder(
      column: $table.mkey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mData => $composableBuilder(
      column: $table.mData, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TlpDatasTableOrderingComposer
    extends Composer<_$AppDatabase, $TlpDatasTable> {
  $$TlpDatasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mkey => $composableBuilder(
      column: $table.mkey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mData => $composableBuilder(
      column: $table.mData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TlpDatasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TlpDatasTable> {
  $$TlpDatasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mkey =>
      $composableBuilder(column: $table.mkey, builder: (column) => column);

  GeneratedColumn<String> get mData =>
      $composableBuilder(column: $table.mData, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TlpDatasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TlpDatasTable,
    TlpData,
    $$TlpDatasTableFilterComposer,
    $$TlpDatasTableOrderingComposer,
    $$TlpDatasTableAnnotationComposer,
    $$TlpDatasTableCreateCompanionBuilder,
    $$TlpDatasTableUpdateCompanionBuilder,
    (TlpData, BaseReferences<_$AppDatabase, $TlpDatasTable, TlpData>),
    TlpData,
    PrefetchHooks Function()> {
  $$TlpDatasTableTableManager(_$AppDatabase db, $TlpDatasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TlpDatasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TlpDatasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TlpDatasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> mkey = const Value.absent(),
            Value<String> mData = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              TlpDatasCompanion(
            id: id,
            mkey: mkey,
            mData: mData,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String mkey,
            required String mData,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              TlpDatasCompanion.insert(
            id: id,
            mkey: mkey,
            mData: mData,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TlpDatasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TlpDatasTable,
    TlpData,
    $$TlpDatasTableFilterComposer,
    $$TlpDatasTableOrderingComposer,
    $$TlpDatasTableAnnotationComposer,
    $$TlpDatasTableCreateCompanionBuilder,
    $$TlpDatasTableUpdateCompanionBuilder,
    (TlpData, BaseReferences<_$AppDatabase, $TlpDatasTable, TlpData>),
    TlpData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TlpDatasTableTableManager get tlpDatas =>
      $$TlpDatasTableTableManager(_db, _db.tlpDatas);
}
