import 'dart:convert';
import 'package:crypto/crypto.dart';

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
  String? algorithm;

  switch (hash.length) {
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

Future<String> safeExecuter(List<String> wordList, String? algorithm, String hash) async {
  if(wordList.isEmpty) {
    return "";
  }

  if (algorithm == 'Unknown') {
    algorithm = hashIdentifier(hash);
    return algorithm ?? "Unable to identify the algorithm";
  }

  return "true";
}

