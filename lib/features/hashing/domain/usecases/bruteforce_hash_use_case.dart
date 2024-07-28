import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_bruteforce_result.dart';
import 'package:flut_crack/features/hashing/domain/repositories/hashing_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class BruteforceHashUseCaseParams {
  final String hash;
  final HashAlgorithmType algorithmType;
  final List<String> wordList;

  const BruteforceHashUseCaseParams({
    required this.hash,
    required this.algorithmType,
    required this.wordList
  });
}

class BruteforceHashUseCase
    implements UseCase<BruteforceHashUseCaseParams, Future<HashBruteforceResult>> {

  final HashingRepository repository;

  BruteforceHashUseCase(this.repository);

  @override
  Future<HashBruteforceResult> call(BruteforceHashUseCaseParams params) async {
    return await repository.bruteforceHash(
      params.hash,
      params.algorithmType,
      params.wordList
    );
  }
}

final bruteforceHashUseCaseProvider = Provider((ref){
  final repository = ref.read(hashingRepositoryProvider);
  return BruteforceHashUseCase(repository);
});