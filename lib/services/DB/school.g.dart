// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.dart';

// ignore_for_file: type=lint
class $SchoolsTable extends Schools with TableInfo<$SchoolsTable, School> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _schoolNameMeta = const VerificationMeta(
    'schoolName',
  );
  @override
  late final GeneratedColumn<String> schoolName = GeneratedColumn<String>(
    'school_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolSNMeta = const VerificationMeta(
    'schoolSN',
  );
  @override
  late final GeneratedColumn<String> schoolSN = GeneratedColumn<String>(
    'school_s_n',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolCodeMeta = const VerificationMeta(
    'schoolCode',
  );
  @override
  late final GeneratedColumn<int> schoolCode = GeneratedColumn<int>(
    'school_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'UNIQUE',
  );
  static const VerificationMeta _schoolTypeMeta = const VerificationMeta(
    'schoolType',
  );
  @override
  late final GeneratedColumn<String> schoolType = GeneratedColumn<String>(
    'school_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalNameMeta = const VerificationMeta(
    'principalName',
  );
  @override
  late final GeneratedColumn<String> principalName = GeneratedColumn<String>(
    'principal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phone1Meta = const VerificationMeta('phone1');
  @override
  late final GeneratedColumn<String> phone1 = GeneratedColumn<String>(
    'phone1',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    schoolName,
    schoolSN,
    schoolCode,
    schoolType,
    principalName,
    phone1,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schools';
  @override
  VerificationContext validateIntegrity(
    Insertable<School> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('school_name')) {
      context.handle(
        _schoolNameMeta,
        schoolName.isAcceptableOrUnknown(data['school_name']!, _schoolNameMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolNameMeta);
    }
    if (data.containsKey('school_s_n')) {
      context.handle(
        _schoolSNMeta,
        schoolSN.isAcceptableOrUnknown(data['school_s_n']!, _schoolSNMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolSNMeta);
    }
    if (data.containsKey('school_code')) {
      context.handle(
        _schoolCodeMeta,
        schoolCode.isAcceptableOrUnknown(data['school_code']!, _schoolCodeMeta),
      );
    }
    if (data.containsKey('school_type')) {
      context.handle(
        _schoolTypeMeta,
        schoolType.isAcceptableOrUnknown(data['school_type']!, _schoolTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolTypeMeta);
    }
    if (data.containsKey('principal_name')) {
      context.handle(
        _principalNameMeta,
        principalName.isAcceptableOrUnknown(
          data['principal_name']!,
          _principalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalNameMeta);
    }
    if (data.containsKey('phone1')) {
      context.handle(
        _phone1Meta,
        phone1.isAcceptableOrUnknown(data['phone1']!, _phone1Meta),
      );
    } else if (isInserting) {
      context.missing(_phone1Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {schoolCode};
  @override
  School map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return School(
      schoolName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_name'],
      )!,
      schoolSN: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_s_n'],
      )!,
      schoolCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}school_code'],
      )!,
      schoolType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_type'],
      )!,
      principalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}principal_name'],
      )!,
      phone1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone1'],
      )!,
    );
  }

  @override
  $SchoolsTable createAlias(String alias) {
    return $SchoolsTable(attachedDatabase, alias);
  }
}

class School extends DataClass implements Insertable<School> {
  final String schoolName;
  final String schoolSN;
  final int schoolCode;
  final String schoolType;
  final String principalName;
  final String phone1;
  const School({
    required this.schoolName,
    required this.schoolSN,
    required this.schoolCode,
    required this.schoolType,
    required this.principalName,
    required this.phone1,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['school_name'] = Variable<String>(schoolName);
    map['school_s_n'] = Variable<String>(schoolSN);
    map['school_code'] = Variable<int>(schoolCode);
    map['school_type'] = Variable<String>(schoolType);
    map['principal_name'] = Variable<String>(principalName);
    map['phone1'] = Variable<String>(phone1);
    return map;
  }

  SchoolsCompanion toCompanion(bool nullToAbsent) {
    return SchoolsCompanion(
      schoolName: Value(schoolName),
      schoolSN: Value(schoolSN),
      schoolCode: Value(schoolCode),
      schoolType: Value(schoolType),
      principalName: Value(principalName),
      phone1: Value(phone1),
    );
  }

  factory School.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return School(
      schoolName: serializer.fromJson<String>(json['schoolName']),
      schoolSN: serializer.fromJson<String>(json['schoolSN']),
      schoolCode: serializer.fromJson<int>(json['schoolCode']),
      schoolType: serializer.fromJson<String>(json['schoolType']),
      principalName: serializer.fromJson<String>(json['principalName']),
      phone1: serializer.fromJson<String>(json['phone1']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'schoolName': serializer.toJson<String>(schoolName),
      'schoolSN': serializer.toJson<String>(schoolSN),
      'schoolCode': serializer.toJson<int>(schoolCode),
      'schoolType': serializer.toJson<String>(schoolType),
      'principalName': serializer.toJson<String>(principalName),
      'phone1': serializer.toJson<String>(phone1),
    };
  }

  School copyWith({
    String? schoolName,
    String? schoolSN,
    int? schoolCode,
    String? schoolType,
    String? principalName,
    String? phone1,
  }) => School(
    schoolName: schoolName ?? this.schoolName,
    schoolSN: schoolSN ?? this.schoolSN,
    schoolCode: schoolCode ?? this.schoolCode,
    schoolType: schoolType ?? this.schoolType,
    principalName: principalName ?? this.principalName,
    phone1: phone1 ?? this.phone1,
  );
  School copyWithCompanion(SchoolsCompanion data) {
    return School(
      schoolName: data.schoolName.present
          ? data.schoolName.value
          : this.schoolName,
      schoolSN: data.schoolSN.present ? data.schoolSN.value : this.schoolSN,
      schoolCode: data.schoolCode.present
          ? data.schoolCode.value
          : this.schoolCode,
      schoolType: data.schoolType.present
          ? data.schoolType.value
          : this.schoolType,
      principalName: data.principalName.present
          ? data.principalName.value
          : this.principalName,
      phone1: data.phone1.present ? data.phone1.value : this.phone1,
    );
  }

  @override
  String toString() {
    return (StringBuffer('School(')
          ..write('schoolName: $schoolName, ')
          ..write('schoolSN: $schoolSN, ')
          ..write('schoolCode: $schoolCode, ')
          ..write('schoolType: $schoolType, ')
          ..write('principalName: $principalName, ')
          ..write('phone1: $phone1')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    schoolName,
    schoolSN,
    schoolCode,
    schoolType,
    principalName,
    phone1,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is School &&
          other.schoolName == this.schoolName &&
          other.schoolSN == this.schoolSN &&
          other.schoolCode == this.schoolCode &&
          other.schoolType == this.schoolType &&
          other.principalName == this.principalName &&
          other.phone1 == this.phone1);
}

class SchoolsCompanion extends UpdateCompanion<School> {
  final Value<String> schoolName;
  final Value<String> schoolSN;
  final Value<int> schoolCode;
  final Value<String> schoolType;
  final Value<String> principalName;
  final Value<String> phone1;
  const SchoolsCompanion({
    this.schoolName = const Value.absent(),
    this.schoolSN = const Value.absent(),
    this.schoolCode = const Value.absent(),
    this.schoolType = const Value.absent(),
    this.principalName = const Value.absent(),
    this.phone1 = const Value.absent(),
  });
  SchoolsCompanion.insert({
    required String schoolName,
    required String schoolSN,
    this.schoolCode = const Value.absent(),
    required String schoolType,
    required String principalName,
    required String phone1,
  }) : schoolName = Value(schoolName),
       schoolSN = Value(schoolSN),
       schoolType = Value(schoolType),
       principalName = Value(principalName),
       phone1 = Value(phone1);
  static Insertable<School> custom({
    Expression<String>? schoolName,
    Expression<String>? schoolSN,
    Expression<int>? schoolCode,
    Expression<String>? schoolType,
    Expression<String>? principalName,
    Expression<String>? phone1,
  }) {
    return RawValuesInsertable({
      if (schoolName != null) 'school_name': schoolName,
      if (schoolSN != null) 'school_s_n': schoolSN,
      if (schoolCode != null) 'school_code': schoolCode,
      if (schoolType != null) 'school_type': schoolType,
      if (principalName != null) 'principal_name': principalName,
      if (phone1 != null) 'phone1': phone1,
    });
  }

  SchoolsCompanion copyWith({
    Value<String>? schoolName,
    Value<String>? schoolSN,
    Value<int>? schoolCode,
    Value<String>? schoolType,
    Value<String>? principalName,
    Value<String>? phone1,
  }) {
    return SchoolsCompanion(
      schoolName: schoolName ?? this.schoolName,
      schoolSN: schoolSN ?? this.schoolSN,
      schoolCode: schoolCode ?? this.schoolCode,
      schoolType: schoolType ?? this.schoolType,
      principalName: principalName ?? this.principalName,
      phone1: phone1 ?? this.phone1,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (schoolName.present) {
      map['school_name'] = Variable<String>(schoolName.value);
    }
    if (schoolSN.present) {
      map['school_s_n'] = Variable<String>(schoolSN.value);
    }
    if (schoolCode.present) {
      map['school_code'] = Variable<int>(schoolCode.value);
    }
    if (schoolType.present) {
      map['school_type'] = Variable<String>(schoolType.value);
    }
    if (principalName.present) {
      map['principal_name'] = Variable<String>(principalName.value);
    }
    if (phone1.present) {
      map['phone1'] = Variable<String>(phone1.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolsCompanion(')
          ..write('schoolName: $schoolName, ')
          ..write('schoolSN: $schoolSN, ')
          ..write('schoolCode: $schoolCode, ')
          ..write('schoolType: $schoolType, ')
          ..write('principalName: $principalName, ')
          ..write('phone1: $phone1')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SchoolsTable schools = $SchoolsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [schools];
}

typedef $$SchoolsTableCreateCompanionBuilder =
    SchoolsCompanion Function({
      required String schoolName,
      required String schoolSN,
      Value<int> schoolCode,
      required String schoolType,
      required String principalName,
      required String phone1,
    });
typedef $$SchoolsTableUpdateCompanionBuilder =
    SchoolsCompanion Function({
      Value<String> schoolName,
      Value<String> schoolSN,
      Value<int> schoolCode,
      Value<String> schoolType,
      Value<String> principalName,
      Value<String> phone1,
    });

class $$SchoolsTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolSN => $composableBuilder(
    column: $table.schoolSN,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schoolCode => $composableBuilder(
    column: $table.schoolCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolType => $composableBuilder(
    column: $table.schoolType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get principalName => $composableBuilder(
    column: $table.principalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone1 => $composableBuilder(
    column: $table.phone1,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchoolsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolSN => $composableBuilder(
    column: $table.schoolSN,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schoolCode => $composableBuilder(
    column: $table.schoolCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolType => $composableBuilder(
    column: $table.schoolType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get principalName => $composableBuilder(
    column: $table.principalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone1 => $composableBuilder(
    column: $table.phone1,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schoolSN =>
      $composableBuilder(column: $table.schoolSN, builder: (column) => column);

  GeneratedColumn<int> get schoolCode => $composableBuilder(
    column: $table.schoolCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schoolType => $composableBuilder(
    column: $table.schoolType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get principalName => $composableBuilder(
    column: $table.principalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone1 =>
      $composableBuilder(column: $table.phone1, builder: (column) => column);
}

class $$SchoolsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolsTable,
          School,
          $$SchoolsTableFilterComposer,
          $$SchoolsTableOrderingComposer,
          $$SchoolsTableAnnotationComposer,
          $$SchoolsTableCreateCompanionBuilder,
          $$SchoolsTableUpdateCompanionBuilder,
          (School, BaseReferences<_$AppDatabase, $SchoolsTable, School>),
          School,
          PrefetchHooks Function()
        > {
  $$SchoolsTableTableManager(_$AppDatabase db, $SchoolsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> schoolName = const Value.absent(),
                Value<String> schoolSN = const Value.absent(),
                Value<int> schoolCode = const Value.absent(),
                Value<String> schoolType = const Value.absent(),
                Value<String> principalName = const Value.absent(),
                Value<String> phone1 = const Value.absent(),
              }) => SchoolsCompanion(
                schoolName: schoolName,
                schoolSN: schoolSN,
                schoolCode: schoolCode,
                schoolType: schoolType,
                principalName: principalName,
                phone1: phone1,
              ),
          createCompanionCallback:
              ({
                required String schoolName,
                required String schoolSN,
                Value<int> schoolCode = const Value.absent(),
                required String schoolType,
                required String principalName,
                required String phone1,
              }) => SchoolsCompanion.insert(
                schoolName: schoolName,
                schoolSN: schoolSN,
                schoolCode: schoolCode,
                schoolType: schoolType,
                principalName: principalName,
                phone1: phone1,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchoolsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolsTable,
      School,
      $$SchoolsTableFilterComposer,
      $$SchoolsTableOrderingComposer,
      $$SchoolsTableAnnotationComposer,
      $$SchoolsTableCreateCompanionBuilder,
      $$SchoolsTableUpdateCompanionBuilder,
      (School, BaseReferences<_$AppDatabase, $SchoolsTable, School>),
      School,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SchoolsTableTableManager get schools =>
      $$SchoolsTableTableManager(_db, _db.schools);
}
