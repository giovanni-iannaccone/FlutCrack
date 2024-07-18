import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory =
          Directory("/storage/emulated/0/Download");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<void> clearDictionary() async {
    final path = await _localPath;
    File file = File('$path/wordlist.txt');
    await file.writeAsString('');
  }

  static Future<List<String>> loadDictionary(File? specialFilePath) async {
    File file;
    final path = await _localPath;

    specialFilePath == null
        ? file = File("$path/wordlist.txt")
        : file = specialFilePath;

    List<String> dictionary;

    try {
      dictionary = await file.readAsLines();
    } catch (e) {
      return [];
    }

    return dictionary;
  }

  static Future<File> writeNewWords(String newWords) async {
    final path = await _localPath;
    File file = File('$path/wordlist.txt');
    return file.writeAsString(newWords, mode: FileMode.append);
  }
}