import 'package:isar/isar.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/models/student.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _initIsar();
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([SchoolSchema, StudentSchema], directory: dir.path);
  }

  // -------------------------------
  // SCHOOL OPERATIONS
  // -------------------------------

  Future<int> addOrUpdateSchool(School school) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      return await isar.schools.put(school);
    });
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
    await isar.writeTxn(() async {
      await isar.schools.delete(id);
    });
  }

  // -------------------------------
  // STUDENT OPERATIONS
  // -------------------------------

  // Add or update student (link to school by schoolId)
  Future<int> addOrUpdateStudent(Student student, int schoolId) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      final school = await isar.schools.get(schoolId);
      if (school != null) {
        student.school.value = school;
      }
      return await isar.students.put(student);
    });
  }

  // Get all students
  Future<List<Student>> getAllStudents() async {
    final isar = await db;
    return await isar.students.where().findAll();
  }

  // Get students linked to a specific school
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

  // Get student by roll number within a school
  Future<Student?> getStudentByRoll(int schoolId, int rollNumber) async {
    final isar = await db;
    return await isar.students
        .filter()
        .school((q) => q.idEqualTo(schoolId))
        .rollNumberEqualTo(rollNumber)
        .findFirst();
  }

  Future<void> deleteStudent(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.students.delete(id);
    });
  }

  Future<void> deleteMultipleSchools(List<int> ids) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.schools.deleteAll(ids);
    });
  }
}
