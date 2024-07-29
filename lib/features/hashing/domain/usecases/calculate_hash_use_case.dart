import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/features/hashing/domain/repositories/hashing_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class CalculateHashUseCaseParams {
  final String word;
  final HashAlgorithmType algorithmType;

  const CalculateHashUseCaseParams({
    required this.word,
    required this.algorithmType,
  });
}

class CalculateHashUseCase extends UseCase<CalculateHashUseCaseParams, String>{

  final HashingRepository repository;

  CalculateHashUseCase(this.repository);

  @override
  String call(CalculateHashUseCaseParams params) {
    return repository.calculateHashOf(
      params.word,
      params.algorithmType
    );
  }
}

final calculateHashUseCaseProvider = Provider((ref){
  final repository = ref.read(hashingRepositoryProvider);
  return CalculateHashUseCase(repository);
});