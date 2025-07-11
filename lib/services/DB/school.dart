import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:myproject/models/school.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'school.g.dart';

/// Drift table to store schools, classes & sections as JSON
class SchoolsInformation extends Table {
  TextColumn get schoolName => text()();
  IntColumn get schoolCode => integer().customConstraint('UNIQUE')();
  TextColumn get schoolType => text()();
  TextColumn get principalName => text()();
  TextColumn get phone1 => text()();
  TextColumn get classesJson => text().nullable()(); // classes stored as JSON
  TextColumn get classSectionsJson =>
      text().nullable()(); // sections stored as JSON

  @override
  Set<Column> get primaryKey => {schoolCode};
}

@DriftDatabase(tables: [SchoolsInformation])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Get all schools
  Future<List<School>> getAllSchools() async {
    try {
      final rows = await select(schoolsInformation).get();
      return rows.map(_mapRowToSchool).toList();
    } catch (e, s) {
      print('⚠️ Error in getAllSchools: $e');
      print(s);
      return [];
    }
  }

  /// Get school by code
  Future<School?> getSchoolByCode(int code) async {
    try {
      final row = await (select(
        schoolsInformation,
      )..where((tbl) => tbl.schoolCode.equals(code))).getSingleOrNull();
      if (row != null) {
        return _mapRowToSchool(row);
      }
      return null;
    } catch (e, s) {
      print('⚠️ Error in getSchoolByCode: $e');
      print(s);
      return null;
    }
  }

  /// Insert or replace school
  Future<void> insertSchool(School school) async {
    try {
      await into(schoolsInformation).insert(
        SchoolsInformationCompanion(
          schoolName: Value(school.schoolName),
          schoolCode: Value(school.schoolCode),
          schoolType: Value(school.schoolType),
          principalName: Value(school.principalName),
          phone1: Value(school.phone1),
          classesJson: Value(jsonEncode(school.classes ?? [])),
          classSectionsJson: Value(jsonEncode(school.classSections ?? {})),
        ),
        mode: InsertMode.insertOrReplace,
      );
    } catch (e, s) {
      print('⚠️ Error in insertSchool: $e');
      print(s);
    }
  }

  /// Update existing school
  Future<void> updateSchool(School school) async {
    try {
      await update(schoolsInformation).replace(
        SchoolsInformationCompanion(
          schoolName: Value(school.schoolName),
          schoolCode: Value(school.schoolCode),
          schoolType: Value(school.schoolType),
          principalName: Value(school.principalName),
          phone1: Value(school.phone1),
          classesJson: Value(jsonEncode(school.classes ?? [])),
          classSectionsJson: Value(jsonEncode(school.classSections ?? {})),
        ),
      );
    } catch (e, s) {
      print('⚠️ Error in updateSchool: $e');
      print(s);
    }
  }

  /// Delete school by code
  Future<void> deleteSchool(int schoolCode) async {
    try {
      await (delete(
        schoolsInformation,
      )..where((tbl) => tbl.schoolCode.equals(schoolCode))).go();
    } catch (e, s) {
      print('⚠️ Error in deleteSchool: $e');
      print(s);
    }
  }

  /// Convert DB row to School model
  School _mapRowToSchool(SchoolsInformationData row) {
    return School(
      schoolName: row.schoolName,
      schoolCode: row.schoolCode,
      schoolType: row.schoolType,
      principalName: row.principalName,
      phone1: row.phone1,
      classes: row.classesJson != null
          ? List<String>.from(json.decode(row.classesJson!))
          : [],
      classSections: row.classSectionsJson != null
          ? (json.decode(row.classSectionsJson!) as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, List<String>.from(value as List)),
            )
          : {},
    );
  }
}

/// Lazy DB initialization
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(file);
  });
}
