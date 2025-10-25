import 'dart:io';
import 'package:path/path.dart' as path;

class FileUtils {
  static void writeFile(String filePath, String content) {
    final file = File(filePath);
    final directory = Directory(path.dirname(filePath));

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    file.writeAsStringSync(content);
  }

  static String readFile(String filePath) {
    return File(filePath).readAsStringSync();
  }

  static bool fileExists(String filePath) {
    return File(filePath).existsSync();
  }

  static bool directoryExists(String dirPath) {
    return Directory(dirPath).existsSync();
  }

  static void createDirectory(String dirPath) {
    Directory(dirPath).createSync(recursive: true);
  }
}
