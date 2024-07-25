import 'package:flut_crack/data/algorithm_type.dart';
import 'package:flut_crack/data/hash_bruteforcer.dart';
import 'package:flut_crack/screens/providers/hash_bruteforcer_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
sealed class HomeState{

  const HomeState();

  factory HomeState.idle() => HomeStateIdle();
  factory HomeState.loading() => HomeStateLoading();
  
  factory HomeState.success({
    required String matchedWord, 
    required int attempts
  }) => HomeStateSuccess(matchedWord, attempts);

  factory HomeState.error(String message) => HomeStateError(message);
}

class HomeStateIdle extends HomeState {}
class HomeStateLoading extends HomeState {}

class HomeStateSuccess extends HomeState {
  final String matchedWord;
  final int attempts;

  const HomeStateSuccess(this.matchedWord, this.attempts);
}

class HomeStateError extends HomeState {
  final String message;
  
  const HomeStateError(this.message);
}

class HomeScreenStateNotifier extends StateNotifier<HomeState> {

  final HashBruteforcer _hashBruteforcer;

  HomeScreenStateNotifier(this._hashBruteforcer) 
    : super(HomeState.idle());

  Future<void> crackHash(String hash, List<String> wordList, AlgorithmType algorithm) async {
    state = HomeState.loading();

    final result = await _hashBruteforcer.crackHash(hash, wordList, algorithm);

    state = result.success
      ? HomeState.success(matchedWord: result.matchedWord!, attempts: result.attempts)
      : HomeState.error("No match found, try with another word list.");
  }

}

final homeStateStateNotifier = 
  StateNotifierProvider.autoDispose<HomeScreenStateNotifier, HomeState>((ref){
    final bruteforcer = ref.watch(hashBruteforceProvider);
    return HomeScreenStateNotifier(bruteforcer);
  });

