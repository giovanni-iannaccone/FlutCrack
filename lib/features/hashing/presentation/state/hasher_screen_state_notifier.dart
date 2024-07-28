import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/features/hashing/domain/usecases/calculate_hash_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HasherScreenStateNotifier extends StateNotifier<bool> {

  final CalculateHashUseCase calculateHashUseCase;

  HasherScreenStateNotifier(this.calculateHashUseCase)
      : super(false);

  String calculateHash(String word, HashAlgorithmType algorithm) {
    return calculateHashUseCase(
      CalculateHashUseCaseParams(
        word: word,
        algorithmType: algorithm
      )
    );
  }
}

final hasherScreenStateNotifier =
  StateNotifierProvider.autoDispose<HasherScreenStateNotifier, bool>((ref){
    final calculateHashUseCase = ref.read(calculateHashUseCaseProvider);
    return HasherScreenStateNotifier(calculateHashUseCase);
  });