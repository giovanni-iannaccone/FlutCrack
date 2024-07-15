import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/wordlist.txt');
}


Future<void> addToDictionary(String newWords) async {
  final file = await _localFile;
  await file.writeAsString(newWords, mode: FileMode.append);
}

String calcHash(String word, String alg) {
  String hash;

  switch (alg) {
    case 'sha-1':
      hash = sha1.convert(utf8.encode(word)).toString();
      break;
    case 'sha-224':
      hash = sha224.convert(utf8.encode(word)).toString();
      break;
    case 'sha-256':
      hash = sha256.convert(utf8.encode(word)).toString();
      break;
    case 'sha-512':
      hash = sha512.convert(utf8.encode(word)).toString();
      break;
    default:
      hash = md5.convert(utf8.encode(word)).toString();
  }

  return hash;
}

Future<void> clearDictionary() async {
  final file = await _localFile;
  await file.writeAsString('');
}

Future<List<String>> loadDictionary(File? specialFilePath) async {
  File file;

  specialFilePath == null
    ? file = await _localFile
    : file = specialFilePath;
  
  List<String> dictionary;

  try {
    dictionary = await file.readAsLines();
  } catch (e) {
    return [];
  }

  return dictionary;
}
