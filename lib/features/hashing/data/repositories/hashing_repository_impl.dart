import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

import 'package:flut_crack/features/hashing/domain/entities/hash_bruteforce_result.dart';
import 'package:flut_crack/features/hashing/domain/repositories/hashing_repository.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';

class HashingRepositoryImpl implements HashingRepository {

  @override
  String calculateHashOf(String word, HashAlgorithmType algorithm) {
    final bytes = utf8.encode(word);

    const algorithmToFunctionMap = {
      HashAlgorithmType.md5: crypto.md5,
      HashAlgorithmType.sha1: crypto.sha1,
      HashAlgorithmType.sha224: crypto.sha224,
      HashAlgorithmType.sha256: crypto.sha256,
      HashAlgorithmType.sha384: crypto.sha384,
      HashAlgorithmType.sha512: crypto.sha512,
      HashAlgorithmType.sha512224: crypto.sha512224,
      HashAlgorithmType.sha512256: crypto.sha512256
    };

    final hashFunction = algorithmToFunctionMap[algorithm];
    return hashFunction!.convert(bytes).toString();
  }

  @override
  HashAlgorithmType identifyHashAlgorithm(String hash) {

      const hashLengthToAlgorithmMap = {
        32: HashAlgorithmType.md5,
        40: HashAlgorithmType.sha1,
        56: HashAlgorithmType.sha224,
        64: HashAlgorithmType.sha256,
        96: HashAlgorithmType.sha384,
        128: HashAlgorithmType.sha512,
      };

      return hashLengthToAlgorithmMap[hash.length] ?? HashAlgorithmType.unknown;
  }

  @override
  Future<HashBruteforceResult> bruteforceHash(
    String hash,
    HashAlgorithmType algorithm,
    List<String> wordList
  ) async {
    int attempts = 0;

    for(final word in wordList){
      attempts++;

      if(calculateHashOf(word, algorithm) != hash) continue;

      return HashBruteforceResult.success(
        attempts: attempts,
        matchedWord: word
      );
    }

    return HashBruteforceResult.failure(attempts: attempts);
  }

}