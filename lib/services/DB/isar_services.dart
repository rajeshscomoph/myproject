import 'package:isar/isar.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/models/student.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static Isar? _isarInstance; // Singleton Isar instance

  IsarService() {
    _initIsar(); // Ensures it's initialized once
  }

  // Initialize or return existing Isar instance
  Future<Isar> get db async {
    if (_isarInstance != null) return _isarInstance!;
    return await _initIsar();
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    _isarInstance = await Isar.open(
      [SchoolSchema, StudentSchema],
      directory: dir.path,
    );
    return _isarInstance!;
  }

  // -------------------------------
  // SCHOOL OPERATIONS
  // -------------------------------

  Future<int> addOrUpdateSchool(School school) async {
    final isar = await db;
    return await isar.writeTxn(() async => await isar.schools.put(school));
    
  }

  Future<List<School>> getAllSchools() async {
    final isar = await db;
    return await isar.schools.where().findAll();
  }

  Future<School?> getSchoolByCode(int schoolCode) async {
    final isar = await db;
    return await isar.schools
        .filter()
        .schoolCodeEqualTo(schoolCode)
        .findFirst();
  }

  Future<void> deleteSchool(int id) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.schools.delete(id));
  }

  Future<void> deleteMultipleSchools(List<int> ids) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.schools.deleteAll(ids));
  }

  // -------------------------------
  // STUDENT OPERATIONS
  // -------------------------------

  Future<int> addOrUpdateStudent(Student student) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      final studentId = await isar.students.put(
        student,
      ); // ✅ Save student first
      await student.school.save(); // ✅ Now safe to save the IsarLink
      return studentId;
    });
  }


  Future<List<Student>> getAllStudents() async {
    final isar = await db;
    return await isar.students.where().findAll();
  }

  Future<List<Student>> getStudentsBySchoolId(int schoolId) async {
    final isar = await db;
    final school = await isar.schools.get(schoolId);
    if (school != null) {
      return await isar.students
          .filter()
          .school((q) => q.idEqualTo(school.id))
          .findAll();
    }
    return [];
  }

  Future<Student?> getStudentByRoll(int schoolId, int rollNumber) async {
    final isar = await db;
    return await isar.students
        .filter()
        .school((q) => q.idEqualTo(schoolId))
        .rollNumberEqualTo(rollNumber)
        .findFirst();
  }
   Future getStudentById(int id) async {
    final isar = await db;
    return await isar.students.get(id);
  }

  Future<void> deleteStudent(int id) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.students.delete(id));
  }
  Future<void> deleteMultipleStudents(List<int> ids) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.students.deleteAll(ids));
  }

  // Optional: close Isar when needed
  Future<void> close() async {
    if (_isarInstance != null) {
      await _isarInstance!.close();
      _isarInstance = null;
    }
  }

 
   
}

