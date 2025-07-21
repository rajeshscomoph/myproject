// log_manager.dart
// log_manager.dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LogManager {
  static final LogManager _instance = LogManager._internal();
  factory LogManager() => _instance;
  LogManager._internal();

  late Logger _logger;
  late File _logFile;

  final int maxRetentionDays = 7;

  Future<void> init() async {
    final logDir = await _getLogDirectory();
    await _cleanupOldLogs(logDir);

    _logFile = await _getLogFile(logDir);
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 5,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      output: MultiOutput([
        if (kDebugMode) ConsoleOutput(),
        _FileOutput(_logFile),
      ]),
    );

  }

  Logger get logger => _logger;

  Future<Directory> _getLogDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final logDir = Directory(p.join(dir.path, 'logs'));
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }
    return logDir;
  }

  Future<File> _getLogFile(Directory logDir) async {
    final filename = _generateLogFileName();
    final filePath = p.join(logDir.path, filename);
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }
    return file;
  }

  String _generateLogFileName() {
    final now = DateTime.now();
    return '${now.year}-${_pad2(now.month)}-${_pad2(now.day)}.log';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');

  Future<void> _cleanupOldLogs(Directory logDir) async {
    final now = DateTime.now();
    final files = logDir.listSync().whereType<File>();

    for (final file in files) {
      final stat = await file.stat();
      final modified = stat.modified;
      final age = now.difference(modified).inDays;
      if (age > maxRetentionDays) {
        try {
          await file.delete();
          debugPrint("Deleted old log file: ${file.path}");
        } catch (e) {
          debugPrint("Failed to delete log file: $e");
        }
      }
    }
  }



  
  static Future<void> writeDeviceAndAppInfo(Logger log) async {
    final buffer = StringBuffer();
    buffer.writeln("==== Device & App Info ====");
    buffer.writeln("Date: ${DateTime.now()}");

    // App info
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      buffer.writeln("App Name: ${packageInfo.appName}");
      buffer.writeln("Version: ${packageInfo.version} (${packageInfo.buildNumber})");
      buffer.writeln("Package: ${packageInfo.packageName}");
    } catch (e, st) {
      log.w("App info unavailable", error: e, stackTrace: st);
    }

    // Device info
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        buffer.writeln("OS: Android ${android.version.release}");
        buffer.writeln("SDK: ${android.version.sdkInt}");
        buffer.writeln("Device: ${android.brand} ${android.model}");
        buffer.writeln("Manufacturer: ${android.manufacturer}");
        buffer.writeln("Hardware: ${android.hardware}");
      } else if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        buffer.writeln("OS: iOS ${ios.systemVersion}");
        buffer.writeln("Device: ${ios.utsname.machine}");
        buffer.writeln("Model: ${ios.model}");
        buffer.writeln("Name: ${ios.name}");
      }
    } catch (e, st) {
      log.w("Device info unavailable", error: e, stackTrace: st);
    }

    buffer.writeln("===========================");

    log.i(buffer.toString());
  }
}


// Custom output to write logs to file
class _FileOutput extends LogOutput {
  final File file;
  late IOSink _sink;
  bool _isClosed = false;

  _FileOutput(this.file) {
    _sink = file.openWrite(mode: FileMode.append);
  }

  @override
  void output(OutputEvent event) async {
    try {
      final raf = await file.open(mode: FileMode.append);
      for (final line in event.lines) {
        await raf.writeString("$line\n");
      }
      await raf.flush();
      await raf.close();
    } catch (e) {
      debugPrint('Log write error: $e');
    }
  }


  @override
  Future<void> destroy() async {
    if (!_isClosed) {
      _isClosed = true;
      await _sink.flush();
      await _sink.close();
    }
  }
}
