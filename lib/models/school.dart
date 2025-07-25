import 'package:isar/isar.dart';
import 'package:myproject/models/student.dart';

part 'school.g.dart';

@collection
class School {
  Id id = Isar.autoIncrement; // Local database ID

  late String schoolName;
  late int schoolCode; // unique code for the school
  late String schoolType;
  late String principalName;
  late String phone1;

  List<String> classes = []; // list of class names like ["1", "2", "3"]

  /// Embedded class sections like:
  /// classSections = [
  ///   ClassSection(className: "1", sections: ["A", "B"])
  /// ]
  /// 
  List<ClassSection> classSections = [];

  /// Backlink from Student -> School (student.school)
  @Backlink(to: 'school')
  final students = IsarLinks<Student>();

  School();

  factory School.fromJson(Map<String, dynamic> json) {
    return School()
      ..schoolName = json['schoolName'] as String
      ..schoolCode = json['schoolCode'] as int
      ..schoolType = json['schoolType'] as String
      ..principalName = json['principalName'] as String
      ..phone1 = json['phone1'] as String
      ..classes = List<String>.from(json['classes'] ?? [])
      ..classSections = (json['classSections'] as List<dynamic>? ?? [])
          .map((e) => ClassSection.fromJson(e as Map<String, dynamic>))
          .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'schoolCode': schoolCode,
      'schoolType': schoolType,
      'principalName': principalName,
      'phone1': phone1,
      'classes': classes,
      'classSections': classSections.map((e) => e.toJson()).toList(),
    };
  }
}

@embedded
class ClassSection {
  late String className; // like "1", "2", "10"
  List<String> sections = []; // like ["A", "B", "C"]

  ClassSection();

  factory ClassSection.fromJson(Map<String, dynamic> json) {
    return ClassSection()
      ..className = json['className'] as String
      ..sections = List<String>.from(json['sections'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {'className': className, 'sections': sections};
  }
}
