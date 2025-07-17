import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String baseUrl;
  final String appName;
  final String lang;

  Config._(this.baseUrl, this.appName,this.lang);

  static Future<Config> load() async {
    await dotenv.load(fileName: "assets/files/.env");
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final appName = dotenv.env['APP_NAME'] ?? '';
    final lang = dotenv.env['LANG'] ?? '';
    return Config._(baseUrl, appName,lang);
  }
}


late Config config;
