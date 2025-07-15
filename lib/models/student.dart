import 'package:isar/isar.dart';
import 'school.dart';

part 'student.g.dart';

@collection
class Student {
  Id id = Isar.autoIncrement;

  late String name;
  late int rollNumber;
  late String gender;
  late int age;

  late String className;
  late String section;

  final school = IsarLink<School>(); // Link to School

  Student();

  factory Student.fromJson(Map<String, dynamic> json) {
    final student = Student()
      ..id = json['id'] as int? ?? Isar.autoIncrement
      ..name = json['name'] as String
      ..rollNumber = json['rollNumber'] as int
      ..gender = json['gender'] as String
      ..age = json['age'] as int
      ..className = json['className'] as String
      ..section = json['section'] as String;

    // ⚠ Note: you cannot restore IsarLink<School> directly from JSON.
    // Instead, you might store schoolId or schoolCode in JSON and link later in code.
    // e.g. store: json['schoolId'] or json['schoolCode']
    return student;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rollNumber': rollNumber,
      'gender': gender,
      'age': age,
      'className': className,
      'section': section,
      // ⚠ Instead of storing the whole School object, store its id or code
      'schoolId': school.value?.id,
    };
  }
}
