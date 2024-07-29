import 'package:flut_crack/features/hashing/data/repositories/hashing_repository_impl.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_bruteforce_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class HashingRepository {

  String calculateHashOf(String word, HashAlgorithmType algorithm);
  HashAlgorithmType identifyHashAlgorithm(String hash);

  Future<HashBruteforceResult> bruteforceHash(
    String hash,
    HashAlgorithmType algorithm,
    List<String> wordList
  );
}

final hashingRepositoryProvider = Provider((ref) => HashingRepositoryImpl());