// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.dart';

// ignore_for_file: type=lint
class $SchoolsInformationTable extends SchoolsInformation
    with TableInfo<$SchoolsInformationTable, SchoolsInformationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolsInformationTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _classesJsonMeta = const VerificationMeta(
    'classesJson',
  );
  @override
  late final GeneratedColumn<String> classesJson = GeneratedColumn<String>(
    'classes_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classSectionsJsonMeta = const VerificationMeta(
    'classSectionsJson',
  );
  @override
  late final GeneratedColumn<String> classSectionsJson =
      GeneratedColumn<String>(
        'class_sections_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    schoolName,
    schoolCode,
    schoolType,
    principalName,
    phone1,
    classesJson,
    classSectionsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schools_information';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchoolsInformationData> instance, {
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
    if (data.containsKey('classes_json')) {
      context.handle(
        _classesJsonMeta,
        classesJson.isAcceptableOrUnknown(
          data['classes_json']!,
          _classesJsonMeta,
        ),
      );
    }
    if (data.containsKey('class_sections_json')) {
      context.handle(
        _classSectionsJsonMeta,
        classSectionsJson.isAcceptableOrUnknown(
          data['class_sections_json']!,
          _classSectionsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {schoolCode};
  @override
  SchoolsInformationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolsInformationData(
      schoolName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_name'],
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
      classesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classes_json'],
      ),
      classSectionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_sections_json'],
      ),
    );
  }

  @override
  $SchoolsInformationTable createAlias(String alias) {
    return $SchoolsInformationTable(attachedDatabase, alias);
  }
}

class SchoolsInformationData extends DataClass
    implements Insertable<SchoolsInformationData> {
  final String schoolName;
  final int schoolCode;
  final String schoolType;
  final String principalName;
  final String phone1;
  final String? classesJson;
  final String? classSectionsJson;
  const SchoolsInformationData({
    required this.schoolName,
    required this.schoolCode,
    required this.schoolType,
    required this.principalName,
    required this.phone1,
    this.classesJson,
    this.classSectionsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['school_name'] = Variable<String>(schoolName);
    map['school_code'] = Variable<int>(schoolCode);
    map['school_type'] = Variable<String>(schoolType);
    map['principal_name'] = Variable<String>(principalName);
    map['phone1'] = Variable<String>(phone1);
    if (!nullToAbsent || classesJson != null) {
      map['classes_json'] = Variable<String>(classesJson);
    }
    if (!nullToAbsent || classSectionsJson != null) {
      map['class_sections_json'] = Variable<String>(classSectionsJson);
    }
    return map;
  }

  SchoolsInformationCompanion toCompanion(bool nullToAbsent) {
    return SchoolsInformationCompanion(
      schoolName: Value(schoolName),
      schoolCode: Value(schoolCode),
      schoolType: Value(schoolType),
      principalName: Value(principalName),
      phone1: Value(phone1),
      classesJson: classesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(classesJson),
      classSectionsJson: classSectionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(classSectionsJson),
    );
  }

  factory SchoolsInformationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolsInformationData(
      schoolName: serializer.fromJson<String>(json['schoolName']),
      schoolCode: serializer.fromJson<int>(json['schoolCode']),
      schoolType: serializer.fromJson<String>(json['schoolType']),
      principalName: serializer.fromJson<String>(json['principalName']),
      phone1: serializer.fromJson<String>(json['phone1']),
      classesJson: serializer.fromJson<String?>(json['classesJson']),
      classSectionsJson: serializer.fromJson<String?>(
        json['classSectionsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'schoolName': serializer.toJson<String>(schoolName),
      'schoolCode': serializer.toJson<int>(schoolCode),
      'schoolType': serializer.toJson<String>(schoolType),
      'principalName': serializer.toJson<String>(principalName),
      'phone1': serializer.toJson<String>(phone1),
      'classesJson': serializer.toJson<String?>(classesJson),
      'classSectionsJson': serializer.toJson<String?>(classSectionsJson),
    };
  }

  SchoolsInformationData copyWith({
    String? schoolName,
    int? schoolCode,
    String? schoolType,
    String? principalName,
    String? phone1,
    Value<String?> classesJson = const Value.absent(),
    Value<String?> classSectionsJson = const Value.absent(),
  }) => SchoolsInformationData(
    schoolName: schoolName ?? this.schoolName,
    schoolCode: schoolCode ?? this.schoolCode,
    schoolType: schoolType ?? this.schoolType,
    principalName: principalName ?? this.principalName,
    phone1: phone1 ?? this.phone1,
    classesJson: classesJson.present ? classesJson.value : this.classesJson,
    classSectionsJson: classSectionsJson.present
        ? classSectionsJson.value
        : this.classSectionsJson,
  );
  SchoolsInformationData copyWithCompanion(SchoolsInformationCompanion data) {
    return SchoolsInformationData(
      schoolName: data.schoolName.present
          ? data.schoolName.value
          : this.schoolName,
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
      classesJson: data.classesJson.present
          ? data.classesJson.value
          : this.classesJson,
      classSectionsJson: data.classSectionsJson.present
          ? data.classSectionsJson.value
          : this.classSectionsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolsInformationData(')
          ..write('schoolName: $schoolName, ')
          ..write('schoolCode: $schoolCode, ')
          ..write('schoolType: $schoolType, ')
          ..write('principalName: $principalName, ')
          ..write('phone1: $phone1, ')
          ..write('classesJson: $classesJson, ')
          ..write('classSectionsJson: $classSectionsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    schoolName,
    schoolCode,
    schoolType,
    principalName,
    phone1,
    classesJson,
    classSectionsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolsInformationData &&
          other.schoolName == this.schoolName &&
          other.schoolCode == this.schoolCode &&
          other.schoolType == this.schoolType &&
          other.principalName == this.principalName &&
          other.phone1 == this.phone1 &&
          other.classesJson == this.classesJson &&
          other.classSectionsJson == this.classSectionsJson);
}

class SchoolsInformationCompanion
    extends UpdateCompanion<SchoolsInformationData> {
  final Value<String> schoolName;
  final Value<int> schoolCode;
  final Value<String> schoolType;
  final Value<String> principalName;
  final Value<String> phone1;
  final Value<String?> classesJson;
  final Value<String?> classSectionsJson;
  const SchoolsInformationCompanion({
    this.schoolName = const Value.absent(),
    this.schoolCode = const Value.absent(),
    this.schoolType = const Value.absent(),
    this.principalName = const Value.absent(),
    this.phone1 = const Value.absent(),
    this.classesJson = const Value.absent(),
    this.classSectionsJson = const Value.absent(),
  });
  SchoolsInformationCompanion.insert({
    required String schoolName,
    this.schoolCode = const Value.absent(),
    required String schoolType,
    required String principalName,
    required String phone1,
    this.classesJson = const Value.absent(),
    this.classSectionsJson = const Value.absent(),
  }) : schoolName = Value(schoolName),
       schoolType = Value(schoolType),
       principalName = Value(principalName),
       phone1 = Value(phone1);
  static Insertable<SchoolsInformationData> custom({
    Expression<String>? schoolName,
    Expression<int>? schoolCode,
    Expression<String>? schoolType,
    Expression<String>? principalName,
    Expression<String>? phone1,
    Expression<String>? classesJson,
    Expression<String>? classSectionsJson,
  }) {
    return RawValuesInsertable({
      if (schoolName != null) 'school_name': schoolName,
      if (schoolCode != null) 'school_code': schoolCode,
      if (schoolType != null) 'school_type': schoolType,
      if (principalName != null) 'principal_name': principalName,
      if (phone1 != null) 'phone1': phone1,
      if (classesJson != null) 'classes_json': classesJson,
      if (classSectionsJson != null) 'class_sections_json': classSectionsJson,
    });
  }

  SchoolsInformationCompanion copyWith({
    Value<String>? schoolName,
    Value<int>? schoolCode,
    Value<String>? schoolType,
    Value<String>? principalName,
    Value<String>? phone1,
    Value<String?>? classesJson,
    Value<String?>? classSectionsJson,
  }) {
    return SchoolsInformationCompanion(
      schoolName: schoolName ?? this.schoolName,
      schoolCode: schoolCode ?? this.schoolCode,
      schoolType: schoolType ?? this.schoolType,
      principalName: principalName ?? this.principalName,
      phone1: phone1 ?? this.phone1,
      classesJson: classesJson ?? this.classesJson,
      classSectionsJson: classSectionsJson ?? this.classSectionsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (schoolName.present) {
      map['school_name'] = Variable<String>(schoolName.value);
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
    if (classesJson.present) {
      map['classes_json'] = Variable<String>(classesJson.value);
    }
    if (classSectionsJson.present) {
      map['class_sections_json'] = Variable<String>(classSectionsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolsInformationCompanion(')
          ..write('schoolName: $schoolName, ')
          ..write('schoolCode: $schoolCode, ')
          ..write('schoolType: $schoolType, ')
          ..write('principalName: $principalName, ')
          ..write('phone1: $phone1, ')
          ..write('classesJson: $classesJson, ')
          ..write('classSectionsJson: $classSectionsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SchoolsInformationTable schoolsInformation =
      $SchoolsInformationTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [schoolsInformation];
}

typedef $$SchoolsInformationTableCreateCompanionBuilder =
    SchoolsInformationCompanion Function({
      required String schoolName,
      Value<int> schoolCode,
      required String schoolType,
      required String principalName,
      required String phone1,
      Value<String?> classesJson,
      Value<String?> classSectionsJson,
    });
typedef $$SchoolsInformationTableUpdateCompanionBuilder =
    SchoolsInformationCompanion Function({
      Value<String> schoolName,
      Value<int> schoolCode,
      Value<String> schoolType,
      Value<String> principalName,
      Value<String> phone1,
      Value<String?> classesJson,
      Value<String?> classSectionsJson,
    });

class $$SchoolsInformationTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolsInformationTable> {
  $$SchoolsInformationTableFilterComposer({
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

  ColumnFilters<String> get classesJson => $composableBuilder(
    column: $table.classesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classSectionsJson => $composableBuilder(
    column: $table.classSectionsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchoolsInformationTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolsInformationTable> {
  $$SchoolsInformationTableOrderingComposer({
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

  ColumnOrderings<String> get classesJson => $composableBuilder(
    column: $table.classesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classSectionsJson => $composableBuilder(
    column: $table.classSectionsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolsInformationTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolsInformationTable> {
  $$SchoolsInformationTableAnnotationComposer({
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

  GeneratedColumn<String> get classesJson => $composableBuilder(
    column: $table.classesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classSectionsJson => $composableBuilder(
    column: $table.classSectionsJson,
    builder: (column) => column,
  );
}

class $$SchoolsInformationTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolsInformationTable,
          SchoolsInformationData,
          $$SchoolsInformationTableFilterComposer,
          $$SchoolsInformationTableOrderingComposer,
          $$SchoolsInformationTableAnnotationComposer,
          $$SchoolsInformationTableCreateCompanionBuilder,
          $$SchoolsInformationTableUpdateCompanionBuilder,
          (
            SchoolsInformationData,
            BaseReferences<
              _$AppDatabase,
              $SchoolsInformationTable,
              SchoolsInformationData
            >,
          ),
          SchoolsInformationData,
          PrefetchHooks Function()
        > {
  $$SchoolsInformationTableTableManager(
    _$AppDatabase db,
    $SchoolsInformationTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolsInformationTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolsInformationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolsInformationTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> schoolName = const Value.absent(),
                Value<int> schoolCode = const Value.absent(),
                Value<String> schoolType = const Value.absent(),
                Value<String> principalName = const Value.absent(),
                Value<String> phone1 = const Value.absent(),
                Value<String?> classesJson = const Value.absent(),
                Value<String?> classSectionsJson = const Value.absent(),
              }) => SchoolsInformationCompanion(
                schoolName: schoolName,
                schoolCode: schoolCode,
                schoolType: schoolType,
                principalName: principalName,
                phone1: phone1,
                classesJson: classesJson,
                classSectionsJson: classSectionsJson,
              ),
          createCompanionCallback:
              ({
                required String schoolName,
                Value<int> schoolCode = const Value.absent(),
                required String schoolType,
                required String principalName,
                required String phone1,
                Value<String?> classesJson = const Value.absent(),
                Value<String?> classSectionsJson = const Value.absent(),
              }) => SchoolsInformationCompanion.insert(
                schoolName: schoolName,
                schoolCode: schoolCode,
                schoolType: schoolType,
                principalName: principalName,
                phone1: phone1,
                classesJson: classesJson,
                classSectionsJson: classSectionsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchoolsInformationTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolsInformationTable,
      SchoolsInformationData,
      $$SchoolsInformationTableFilterComposer,
      $$SchoolsInformationTableOrderingComposer,
      $$SchoolsInformationTableAnnotationComposer,
      $$SchoolsInformationTableCreateCompanionBuilder,
      $$SchoolsInformationTableUpdateCompanionBuilder,
      (
        SchoolsInformationData,
        BaseReferences<
          _$AppDatabase,
          $SchoolsInformationTable,
          SchoolsInformationData
        >,
      ),
      SchoolsInformationData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SchoolsInformationTableTableManager get schoolsInformation =>
      $$SchoolsInformationTableTableManager(_db, _db.schoolsInformation);
}
