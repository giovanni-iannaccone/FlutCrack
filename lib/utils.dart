import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

String calcHash(String word, String alg) {
  String hash;
  var bytes = utf8.encode(word);

  switch (alg) {
    case 'sha-1':
      hash = sha1.convert(bytes).toString();
      break;

    case 'sha-224':
      hash = sha224.convert(bytes).toString();
      break;

    case 'sha-256':
      hash = sha256.convert(bytes).toString();
      break;

    case 'sha-384':
      hash = sha384.convert(bytes).toString();
      break;

    case 'sha-512':
      hash = sha512.convert(bytes).toString();
      break;

    case 'sha-512/224':
      hash = sha512224.convert(bytes).toString();
      break;

    case 'sha-512/256':
      hash = sha512256.convert(bytes).toString();
      break;

    default:
      hash = md5.convert(bytes).toString();
  }

  return hash;
}

String? hashIdentifier(String hash) {
  int length = hash.length;
  String? algorithm;

  switch (length) {
    case 32:
      algorithm = 'md5';
      break;
    
    case 40:
      algorithm = 'sha-1';
      break;
    
    case 56:
      algorithm = 'sha-224';
      break;
    
    case 64:
      algorithm = 'sha-256';
      break;

    case 96:
      algorithm = 'sha-384';
      break;
    
    case 128:
      algorithm = 'sha-512';
      break;

    default:
      algorithm = null;
  }

  return algorithm;
}

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

Future<String> safeExecuter(List<String> wordList, String? algorithm, String hash) async {
  if(wordList.isEmpty) {
    return "";
  }

  if (algorithm == 'Unknown') {
    algorithm = hashIdentifier(hash);
    return algorithm!;
  }

  if(algorithm == null) {
    return "Unable to identify the algorithm";
  }

  return "true";
}
