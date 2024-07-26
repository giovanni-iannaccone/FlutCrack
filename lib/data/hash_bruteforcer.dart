
import 'package:flut_crack/data/hasher.dart';
import 'package:flutter/material.dart';

import 'algorithm_type.dart';

@immutable
class HashBruteforcingResult {
  final bool success;
  final int attempts;
  final String? matchedWord;

  const HashBruteforcingResult.success({
    required this.attempts,
    required this.matchedWord
  }) : success = true;

  const HashBruteforcingResult.failure({required this.attempts}) 
    : success = false,
      matchedWord = null;

}

class HashBruteforcer {

  final Hasher _hasher;

  const HashBruteforcer(this._hasher);

  Future<HashBruteforcingResult> crackHash(
    String hash, 
    List<String> wordList,
    AlgorithmType algorithm
  ) async {

    int attempts = 0;
    
    for(final word in wordList){
      attempts++;

      if(_hasher.calculateHash(word, algorithm) != hash) {
        continue;
      }

      return HashBruteforcingResult.success(
        attempts: attempts, 
        matchedWord: word
      );
    }

    return HashBruteforcingResult.failure(attempts: attempts);
  }
}