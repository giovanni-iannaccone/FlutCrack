
import 'package:flut_crack/utils/hash_utils.dart';

import 'algorithm_type.dart';

class HashCrackingResult {
  final int triedWordsCount;
  final bool success;
  final String? matchedWord;
  
  const HashCrackingResult({
    required this.triedWordsCount,
    required this.matchedWord,
    required this.success
  });

  factory HashCrackingResult.success({
    required int triedWords,
    required String message
  }) => HashCrackingResult(
    triedWordsCount: triedWords,
    matchedWord: message,
    success: true
  );

  factory HashCrackingResult.failure({
    required int triedWords
  }) => HashCrackingResult(
    triedWordsCount: triedWords,
    matchedWord: null,
    success: false
  );

}

class HashCracker {
  Future<HashCrackingResult> crack(
    String hash, 
    List<String> wordList,
    AlgorithmType algorithm
  ) async {

    int triedWords = 0;
    
    for(final word in wordList){
      triedWords++;
      if(calculateHash(word, algorithm) == hash){
        return HashCrackingResult.success(
          triedWords: triedWords, 
          message: word
        );
      }
    }

    return HashCrackingResult.failure(triedWords: triedWords);
  }
}