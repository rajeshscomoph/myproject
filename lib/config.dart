import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:myproject/services/logs/log_manager.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Config {
  final String baseUrl;
  final String appName;
  final String lang;
  
  final String organizationName = "Community Ophthalmology";
  final String contactInfo = "Help Line: 011-26593140";
  final String copyright = "© 2025 Community Ophthalmology";

  late Logger logger;



  Config._(this.baseUrl, this.appName,this.lang) {
    logger = LogManager().logger;
  }

  static Future<Config> load() async {
    await dotenv.load(fileName: "assets/files/.env");
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final appName = dotenv.env['APP_NAME'] ?? '';
    final lang = dotenv.env['LANG'] ?? '';
    return Config._(baseUrl, appName,lang);
  }
}


late Config config;


enum SchoolType {all, govt, private, other }

extension SchoolTypeExtension on SchoolType {
  String get label => EnumToString.convertToString(this, camelCase: false);

  static SchoolType? fromString(String label) {
    return EnumToString.fromString(SchoolType.values, label, camelCase: false);
  }
  
  IconData get icon {
    switch (this) {
      case SchoolType.govt:
        return Icons.apartment;
      case SchoolType.private:
        return Icons.school;
      case SchoolType.other:
        return Icons.help_outline;
      case SchoolType.all:
        return Icons.list;
    }
  }

}


enum ExaminationStatus { all,examined, absent, refused }

extension ExaminationStatusExtension on ExaminationStatus {
  String get label => EnumToString.convertToString(this, camelCase: false);

  static ExaminationStatus? fromString(String label) {
    return EnumToString.fromString(
      ExaminationStatus.values, label, camelCase: false);
  }

}
