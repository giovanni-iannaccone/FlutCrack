import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/features/hashing/domain/repositories/hashing_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdentifyHashUseCase extends UseCase<String, HashAlgorithmType>{

  final HashingRepository repository;

  IdentifyHashUseCase(this.repository);

  @override
  HashAlgorithmType call(String params) {
    return repository.identifyHashAlgorithm(params);
  }
}


final identifyHashUseCaseProvider = Provider((ref){
  final repository = ref.read(hashingRepositoryProvider);
  return IdentifyHashUseCase(repository);
});