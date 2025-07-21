import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myproject/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';

class LogUploader {
  Future<File> zipLogs() async {
    final dir = await getApplicationDocumentsDirectory();
    final logsDir = Directory(p.join(dir.path, 'logs'));

    if (!await logsDir.exists()) {
      throw Exception("Logs folder not found.");
    }

    final zipFile = File(p.join(dir.path, 'logs.zip'));
    final encoder = ZipFileEncoder();
    encoder.create(zipFile.path);

    for (var entity in logsDir.listSync()) {
      if (entity is File && entity.path.endsWith('.log')) {
        encoder.addFile(entity);
      }
    }

    encoder.close();
    return zipFile;
  }

  Future<void> uploadToServer({required Uri endpoint}) async {
    final zip = await zipLogs();
    final request = http.MultipartRequest('POST', endpoint);
    request.files.add(await http.MultipartFile.fromPath('file', zip.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      config.logger.d('✅ Log uploaded successfully!');
    } else {
      config.logger.d('❌ Failed to upload log. Status: ${response.statusCode}');
    }
  }
}
