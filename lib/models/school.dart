// lib/models/school.dart
import 'dart:convert';

class School {
  final String schoolName;
  final int schoolCode;
  final String schoolType;
  final String principalName;
  final String phone1;
  final List<String>? classes;
  final Map<String, List<String>>? classSections;

  School({
    required this.schoolName,
    required this.schoolCode,
    required this.schoolType,
    required this.principalName,
    required this.phone1,
    this.classes,
    this.classSections,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolName: json['schoolName'],
      schoolCode: json['schoolCode'],
      schoolType: json['schoolType'],
      principalName: json['principalName'],
      phone1: json['phone1'],
      classes: json['classes'] != null
          ? List<String>.from(jsonDecode(json['classes']))
          : [],
      classSections: json['classSections'] != null
          ? (jsonDecode(json['classSections']) as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, List<String>.from(value as List)),
            )
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'schoolCode': schoolCode,
      'schoolType': schoolType,
      'principalName': principalName,
      'phone1': phone1,
      'classes': jsonEncode(classes ?? []),
      'classSections': jsonEncode(classSections ?? {}),
    };
  }
}
