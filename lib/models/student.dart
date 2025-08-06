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
   String? wearGlass; // Wear Glass
   String? contactLens; // Contact Lens
   String? cutoffUVA1; // Cutoff UVA1
   String? cutoffUVA2; // Cutoff UVA2
   String? eyeTest; // Eye Test
   String? referred; // Referred
   String? phone; // Phone Number

  late String className; // Class
  late String section; // Section
   String? uva1;
   String? uva2;
   String? pva1;
   String? pva2;
   String? pog;
   String? pogSph1;
   String? pogCly1;
   String? pogAxis1;
   String? pogSph2;
   String? pogCly2;
   String? pogAxis2;
   String? cyclo;

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
      ..wearGlass = json['wearGlass'] as String?
      ..contactLens = json['contactLens'] as String?
      ..cutoffUVA1 = json['cutoffUVA1'] as String?
      ..cutoffUVA2 = json['cutoffUVA2'] as String?
      ..eyeTest = json['eyeTest'] as String?
      ..referred = json['referred'] as String?
      ..phone = json['phone'] as String?
      ..className = json['className'] as String
      ..section = json['section'] as String
      ..uva1 = json['uva1'] as String?
      ..uva2 = json['uva2'] as String?
      ..pva1 = json['pva1'] as String?
      ..pva2 = json['pva2'] as String?
      ..pog = json['pog'] as String?
      ..pogSph1 = json['pogSph1'] as String?
      ..pogCly1 = json['pogCly1'] as String?
      ..pogAxis1 = json['pogAxis1'] as String?
      ..pogSph2 = json['pogSph2'] as String?
      ..pogCly2 = json['pogCly2'] as String?
      ..pogAxis2 = json['pogAxis2'] as String?
      ..cyclo = json['cyclo'] as String?;

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
      'uva1': uva1,
      'uva2': uva2,
      'pva1': pva1,
      'pva2': pva2,
      'pog': pog,
      'pogSph1': pogSph1,
      'pogCly1': pogCly1,
      'pogAxis1': pogAxis1,
      'pogSph2': pogSph2,
      'pogCly2': pogCly2,
      'pogAxis2': pogAxis2,
      'cyclo': cyclo,
      'schoolId': school.value?.id,
    };
  }
}
