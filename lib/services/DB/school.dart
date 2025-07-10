// lib/data/local/db.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// ignore: unused_import
import 'package:myproject/models/school.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'school.g.dart';

class Schools extends Table {
  TextColumn get schoolName => text()();
  TextColumn get schoolSN => text()();
  IntColumn get schoolCode => integer().customConstraint('UNIQUE')();
  TextColumn get schoolType => text()();
  TextColumn get principalName => text()();
  TextColumn get phone1 => text()();

  @override
  Set<Column> get primaryKey => {schoolCode};
}

@DriftDatabase(tables: [Schools])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD
  Future<List<School>> getAllSchools() async {
    final rows = await select(schools).get();
    return rows
        .map(
          (e) => School(
            schoolName: e.schoolName,
            schoolSN: e.schoolSN,
            schoolCode: e.schoolCode,
            schoolType: e.schoolType,
            principalName: e.principalName,
            phone1: e.phone1,
          ),
        )
        .toList();
  }

  Future insertSchool(School school) => into(schools).insert(
    SchoolsCompanion(
      schoolName: Value(school.schoolName),
      schoolSN: Value(school.schoolSN),
      schoolCode: Value(school.schoolCode),
      schoolType: Value(school.schoolType),
      principalName: Value(school.principalName),
      phone1: Value(school.phone1),
    ),
    mode: InsertMode.insertOrReplace,
  );

  Future updateSchool(School school) => update(schools).replace(
    SchoolsCompanion(
      schoolName: Value(school.schoolName),
      schoolSN: Value(school.schoolSN),
      schoolCode: Value(school.schoolCode),
      schoolType: Value(school.schoolType),
      principalName: Value(school.principalName),
      phone1: Value(school.phone1),
    ),
  );

  Future deleteSchool(int schoolCode) =>
      (delete(schools)..where((tbl) => tbl.schoolCode.equals(schoolCode))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
