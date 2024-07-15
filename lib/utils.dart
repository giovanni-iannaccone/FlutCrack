import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

// Add a type annotation for the parameter and correct the file handling
Future<void> addToDictionary(String newWords) async {
  final file = await _localFile;
  await file.writeAsString(newWords, mode: FileMode.append);
}

// Correct the type annotations and logic errors in hash calculation
String calcHash(String word, String alg) {
  String hash;

  switch (alg) {
    case 'base64':
      hash = base64Decode(word).toString();
      break;
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

// Correct the file handling and potential null errors
Future<void> clearDictionary() async {
  final file = await _localFile;
  await file.writeAsString('');
}

// Correct the type annotations and file handling
Future<List<String>> loadDictionary() async {
  final file = await _localFile;
  List<String> dictionary;

  try {
    dictionary = await file.readAsLines();
  } catch (e) {
    return [];
  }

  return dictionary;
}

// Correctly implement the _localPath function
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// Correctly implement the _localFile function
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/wordlist.txt');
}
