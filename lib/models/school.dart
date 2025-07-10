class School {
  final String schoolName;
  final String schoolSN;
  final int schoolCode;
  final String schoolType;
  final String principalName;
  final String phone1;

  School({
    required this.schoolName,
    required this.schoolSN,
    required this.schoolCode,
    required this.schoolType,
    required this.principalName,
    required this.phone1,
  });

  // JSON conversion
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolName: json['schoolName'],
      schoolSN: json['schoolSN'],
      schoolCode: json['schoolCode'],
      schoolType: json['schoolType'],
      principalName: json['principalName'],
      phone1: json['phone1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'schoolSN': schoolSN,
      'schoolCode': schoolCode,
      'schoolType': schoolType,
      'principalName': principalName,
      'phone1': phone1,
    };
  }
}
