import 'package:flut_crack/features/hashing/domain/usecases/load_word_list_use_case.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/features/hashing/domain/usecases/bruteforce_hash_use_case.dart';
import 'package:flut_crack/features/hashing/domain/usecases/identify_hash_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
sealed class HashCrackerScreenState {

  const HashCrackerScreenState();

  factory HashCrackerScreenState.idle() => HashCrackerScreenStateIdle();
  factory HashCrackerScreenState.loading() => HashCrackerScreenStateLoading();
  
  factory HashCrackerScreenState.success({
    required String matchedWord, 
    required int attempts
  }) => HashCrackerScreenStateSuccess(matchedWord, attempts);

  factory HashCrackerScreenState.error(String message) => HashCrackerScreenStateError(message);
}

class HashCrackerScreenStateIdle extends HashCrackerScreenState {}
class HashCrackerScreenStateLoading extends HashCrackerScreenState {}

class HashCrackerScreenStateSuccess extends HashCrackerScreenState {
  final String matchedWord;
  final int attempts;

  const HashCrackerScreenStateSuccess(this.matchedWord, this.attempts);
}

class HashCrackerScreenStateError extends HashCrackerScreenState {
  final String message;
  
  const HashCrackerScreenStateError(this.message);
}

class HashCrackerScreenNotifier extends StateNotifier<HashCrackerScreenState> {

  final IdentifyHashUseCase identifyHashUseCase;
  final BruteforceHashUseCase bruteforceHashUseCase;
  final LoadWordListUseCase loadWordListUseCase;

  HashCrackerScreenNotifier({
    required this.bruteforceHashUseCase,
    required this.identifyHashUseCase,
    required this.loadWordListUseCase
  }) : super(HashCrackerScreenState.idle());

  Future<void> crackHash(String hash, String wordListName, HashAlgorithmType algorithm) async {
    state = HashCrackerScreenState.loading();

    final wordList = await loadWordListUseCase(wordListName);
    final result = await bruteforceHashUseCase(
      BruteforceHashUseCaseParams(
        hash: hash,
        algorithmType: algorithm,
        wordList: wordList
      )
    );

    state = result.success
      ? HashCrackerScreenState.success(matchedWord: result.matchedWord!, attempts: result.attempts)
      : HashCrackerScreenState.error("No match found, try with another word list.");
  }

  HashAlgorithmType identifyHash(String hash)  {
    return identifyHashUseCase(hash);
  }
}

final hashCrackerScreenNotifier =
  StateNotifierProvider.autoDispose<HashCrackerScreenNotifier, HashCrackerScreenState>((ref){
    final bruteforceUseCase = ref.watch(bruteforceHashUseCaseProvider);
    final identifyUseCase = ref.watch(identifyHashUseCaseProvider);
    final loadWordListUseCase = ref.read(loadWordListUseCaseProvider);

    return HashCrackerScreenNotifier(
      bruteforceHashUseCase: bruteforceUseCase,
      identifyHashUseCase: identifyUseCase,
      loadWordListUseCase: loadWordListUseCase
    );
  });

