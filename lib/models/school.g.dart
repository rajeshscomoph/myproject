// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSchoolCollection on Isar {
  IsarCollection<School> get schools => this.collection();
}

const SchoolSchema = CollectionSchema(
  name: r'School',
  id: 6936659131449204964,
  properties: {
    r'classSections': PropertySchema(
      id: 0,
      name: r'classSections',
      type: IsarType.objectList,
      target: r'ClassSection',
    ),
    r'classes': PropertySchema(
      id: 1,
      name: r'classes',
      type: IsarType.stringList,
    ),
    r'phone1': PropertySchema(
      id: 2,
      name: r'phone1',
      type: IsarType.string,
    ),
    r'principalName': PropertySchema(
      id: 3,
      name: r'principalName',
      type: IsarType.string,
    ),
    r'schoolCode': PropertySchema(
      id: 4,
      name: r'schoolCode',
      type: IsarType.long,
    ),
    r'schoolName': PropertySchema(
      id: 5,
      name: r'schoolName',
      type: IsarType.string,
    ),
    r'schoolType': PropertySchema(
      id: 6,
      name: r'schoolType',
      type: IsarType.string,
    )
  },
  estimateSize: _schoolEstimateSize,
  serialize: _schoolSerialize,
  deserialize: _schoolDeserialize,
  deserializeProp: _schoolDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'students': LinkSchema(
      id: 3833445609827353890,
      name: r'students',
      target: r'Student',
      single: false,
      linkName: r'school',
    )
  },
  embeddedSchemas: {r'ClassSection': ClassSectionSchema},
  getId: _schoolGetId,
  getLinks: _schoolGetLinks,
  attach: _schoolAttach,
  version: '3.1.0+1',
);

int _schoolEstimateSize(
  School object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.classSections.length * 3;
  {
    final offsets = allOffsets[ClassSection]!;
    for (var i = 0; i < object.classSections.length; i++) {
      final value = object.classSections[i];
      bytesCount += ClassSectionSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.classes.length * 3;
  {
    for (var i = 0; i < object.classes.length; i++) {
      final value = object.classes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.phone1.length * 3;
  bytesCount += 3 + object.principalName.length * 3;
  bytesCount += 3 + object.schoolName.length * 3;
  bytesCount += 3 + object.schoolType.length * 3;
  return bytesCount;
}

void _schoolSerialize(
  School object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<ClassSection>(
    offsets[0],
    allOffsets,
    ClassSectionSchema.serialize,
    object.classSections,
  );
  writer.writeStringList(offsets[1], object.classes);
  writer.writeString(offsets[2], object.phone1);
  writer.writeString(offsets[3], object.principalName);
  writer.writeLong(offsets[4], object.schoolCode);
  writer.writeString(offsets[5], object.schoolName);
  writer.writeString(offsets[6], object.schoolType);
}

School _schoolDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = School();
  object.classSections = reader.readObjectList<ClassSection>(
        offsets[0],
        ClassSectionSchema.deserialize,
        allOffsets,
        ClassSection(),
      ) ??
      [];
  object.classes = reader.readStringList(offsets[1]) ?? [];
  object.id = id;
  object.phone1 = reader.readString(offsets[2]);
  object.principalName = reader.readString(offsets[3]);
  object.schoolCode = reader.readLong(offsets[4]);
  object.schoolName = reader.readString(offsets[5]);
  object.schoolType = reader.readString(offsets[6]);
  return object;
}

P _schoolDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<ClassSection>(
            offset,
            ClassSectionSchema.deserialize,
            allOffsets,
            ClassSection(),
          ) ??
          []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _schoolGetId(School object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _schoolGetLinks(School object) {
  return [object.students];
}

void _schoolAttach(IsarCollection<dynamic> col, Id id, School object) {
  object.id = id;
  object.students.attach(col, col.isar.collection<Student>(), r'students', id);
}

extension SchoolQueryWhereSort on QueryBuilder<School, School, QWhere> {
  QueryBuilder<School, School, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SchoolQueryWhere on QueryBuilder<School, School, QWhereClause> {
  QueryBuilder<School, School, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<School, School, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<School, School, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<School, School, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<School, School, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SchoolQueryFilter on QueryBuilder<School, School, QFilterCondition> {
  QueryBuilder<School, School, QAfterFilterCondition>
      classSectionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classSections',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classSectionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classSections',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition>
      classSectionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classSections',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition>
      classSectionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classSections',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition>
      classSectionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classSections',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition>
      classSectionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classSections',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'classes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'classes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'classes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'classes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'classes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'classes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'classes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'classes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'classes',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition>
      classesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'classes',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> classesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'classes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone1',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone1',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> phone1IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone1',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'principalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'principalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'principalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'principalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'principalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'principalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'principalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'principalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> principalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'principalName',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition>
      principalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'principalName',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schoolCode',
        value: value,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schoolCode',
        value: value,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schoolCode',
        value: value,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schoolCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schoolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schoolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schoolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schoolName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'schoolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'schoolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'schoolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'schoolName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schoolName',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'schoolName',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schoolType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schoolType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schoolType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schoolType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'schoolType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'schoolType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'schoolType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'schoolType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schoolType',
        value: '',
      ));
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> schoolTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'schoolType',
        value: '',
      ));
    });
  }
}

extension SchoolQueryObject on QueryBuilder<School, School, QFilterCondition> {
  QueryBuilder<School, School, QAfterFilterCondition> classSectionsElement(
      FilterQuery<ClassSection> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'classSections');
    });
  }
}

extension SchoolQueryLinks on QueryBuilder<School, School, QFilterCondition> {
  QueryBuilder<School, School, QAfterFilterCondition> students(
      FilterQuery<Student> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'students');
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> studentsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'students', length, true, length, true);
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> studentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'students', 0, true, 0, true);
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> studentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'students', 0, false, 999999, true);
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> studentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'students', 0, true, length, include);
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> studentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'students', length, include, 999999, true);
    });
  }

  QueryBuilder<School, School, QAfterFilterCondition> studentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'students', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SchoolQuerySortBy on QueryBuilder<School, School, QSortBy> {
  QueryBuilder<School, School, QAfterSortBy> sortByPhone1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone1', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortByPhone1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone1', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortByPrincipalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalName', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortByPrincipalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalName', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortBySchoolCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolCode', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortBySchoolCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolCode', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortBySchoolName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolName', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortBySchoolNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolName', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortBySchoolType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolType', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> sortBySchoolTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolType', Sort.desc);
    });
  }
}

extension SchoolQuerySortThenBy on QueryBuilder<School, School, QSortThenBy> {
  QueryBuilder<School, School, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenByPhone1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone1', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenByPhone1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone1', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenByPrincipalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalName', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenByPrincipalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalName', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenBySchoolCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolCode', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenBySchoolCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolCode', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenBySchoolName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolName', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenBySchoolNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolName', Sort.desc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenBySchoolType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolType', Sort.asc);
    });
  }

  QueryBuilder<School, School, QAfterSortBy> thenBySchoolTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schoolType', Sort.desc);
    });
  }
}

extension SchoolQueryWhereDistinct on QueryBuilder<School, School, QDistinct> {
  QueryBuilder<School, School, QDistinct> distinctByClasses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'classes');
    });
  }

  QueryBuilder<School, School, QDistinct> distinctByPhone1(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone1', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<School, School, QDistinct> distinctByPrincipalName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'principalName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<School, School, QDistinct> distinctBySchoolCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schoolCode');
    });
  }

  QueryBuilder<School, School, QDistinct> distinctBySchoolName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schoolName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<School, School, QDistinct> distinctBySchoolType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schoolType', caseSensitive: caseSensitive);
    });
  }
}

extension SchoolQueryProperty on QueryBuilder<School, School, QQueryProperty> {
  QueryBuilder<School, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<School, List<ClassSection>, QQueryOperations>
      classSectionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'classSections');
    });
  }

  QueryBuilder<School, List<String>, QQueryOperations> classesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'classes');
    });
  }

  QueryBuilder<School, String, QQueryOperations> phone1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone1');
    });
  }

  QueryBuilder<School, String, QQueryOperations> principalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'principalName');
    });
  }

  QueryBuilder<School, int, QQueryOperations> schoolCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schoolCode');
    });
  }

  QueryBuilder<School, String, QQueryOperations> schoolNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schoolName');
    });
  }

  QueryBuilder<School, String, QQueryOperations> schoolTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schoolType');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ClassSectionSchema = Schema(
  name: r'ClassSection',
  id: 52507213034872859,
  properties: {
    r'className': PropertySchema(
      id: 0,
      name: r'className',
      type: IsarType.string,
    ),
    r'sections': PropertySchema(
      id: 1,
      name: r'sections',
      type: IsarType.stringList,
    )
  },
  estimateSize: _classSectionEstimateSize,
  serialize: _classSectionSerialize,
  deserialize: _classSectionDeserialize,
  deserializeProp: _classSectionDeserializeProp,
);

int _classSectionEstimateSize(
  ClassSection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.className.length * 3;
  bytesCount += 3 + object.sections.length * 3;
  {
    for (var i = 0; i < object.sections.length; i++) {
      final value = object.sections[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _classSectionSerialize(
  ClassSection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.className);
  writer.writeStringList(offsets[1], object.sections);
}

ClassSection _classSectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClassSection();
  object.className = reader.readString(offsets[0]);
  object.sections = reader.readStringList(offsets[1]) ?? [];
  return object;
}

P _classSectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ClassSectionQueryFilter
    on QueryBuilder<ClassSection, ClassSection, QFilterCondition> {
  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'className',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'className',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'className',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'className',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'className',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'className',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'className',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'className',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'className',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      classNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'className',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sections',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sections',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sections',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sections',
        value: '',
      ));
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ClassSection, ClassSection, QAfterFilterCondition>
      sectionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ClassSectionQueryObject
    on QueryBuilder<ClassSection, ClassSection, QFilterCondition> {}
