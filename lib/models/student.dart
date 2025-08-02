import 'package:isar/isar.dart';
import 'school.dart';

part 'student.g.dart';

@collection
class Student {
  Id id = Isar.autoIncrement;
  late String enrollNo; // Enrollment No
  late int rollNumber; // Roll Number
  late String name; // Student Name
  late String gender; // Gender
  late DateTime dob; // Date of Birth
  late String examination; // Examination
  late String wearGlass; // Wear Glass
  late String contactLens; // Contact Lens
  late String cutoffUVA1; // Cutoff UVA1
  late String cutoffUVA2; // Cutoff UVA2
  late String eyeTest; // Eye Test
  late String referred; // Referred
  late String phone; // Phone Number

  late String className; // Class
  late String section; // Section

  final school = IsarLink<School>(); // Link to School
late String schoolCode;
  Student();

  factory Student.fromJson(Map<String, dynamic> json) {
    final student = Student()
      ..id = json['id'] as int? ?? Isar.autoIncrement
      ..enrollNo = json['enrollNo'] as String
      ..rollNumber = json['rollNumber'] as int
      ..name = json['name'] as String
      ..gender = json['gender'] as String
      ..dob = DateTime.parse(json['dob'] as String)
      ..examination = json['examination'] as String
      ..wearGlass = json['wearGlass'] as String
      ..contactLens = json['contactLens'] as String
      ..cutoffUVA1 = json['cutoffUVA1'] as String
      ..cutoffUVA2 = json['cutoffUVA2'] as String
      ..eyeTest = json['eyeTest'] as String
      ..referred = json['referred'] as String
      ..phone = json['phone'] as String
      ..className = json['className'] as String
      ..section = json['section'] as String;

    // Note: link to school must be established manually via .school.value = someSchool
    return student;
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enrollNo': enrollNo,
      'rollNumber': rollNumber,
      'name': name,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'examination': examination,
      'wearGlass': wearGlass,
      'contactLens': contactLens,
      'cutoffUVA1': cutoffUVA1,
      'cutoffUVA2': cutoffUVA2,
      'eyeTest': eyeTest,
      'referred': referred,
      'phone': phone,
      'className': className,
      'section': section,
      'schoolId': school.value?.id, // optionally store related school ID
    };
  }
}


