import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final file = File("/Android/data/flutcrak/files/wordlist.txt");

Future addToDictionary(newWords) async {
  await file.writeAsString(newWords, mode: FileMode.append);
}

String calcHash(word, alg) {
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

    case 'sha5-12':
      hash = sha512.convert(utf8.encode(word)).toString();
      break;

    default:
      hash = md5.convert(utf8.encode(word)).toString();
  }

  return hash;
}

Future clearDictionary() async {
  await file.writeAsString('');
}

List<String> loadDictionary() {
  List<String> dictionary;

  try {
    dictionary = file.readAsLinesSync();
  } catch (e) {
    return [];
  }

  return dictionary;
}
