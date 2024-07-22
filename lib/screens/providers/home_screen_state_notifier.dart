import 'package:flut_crack/data/algorithm_type.dart';
import 'package:flut_crack/data/hash_cracker.dart';
import 'package:flut_crack/screens/providers/hash_cracker_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState{
  
  final bool isLoading;
  final HashCrackingResult? result;
  
  const HomeState({
    this.isLoading = false,
    this.result
  });

  factory HomeState.none() => const HomeState();
  factory HomeState.loading() => const HomeState(isLoading: true);
  factory HomeState.result(HashCrackingResult res) => HomeState(isLoading: false, result: res);
}

class HomeScreenStateNotifier extends StateNotifier<HomeState> {

  final HashCracker _hashCracker;

  HomeScreenStateNotifier(this._hashCracker) : super(HomeState.none());

  Future<void> crack(String hash, List<String> wordList, AlgorithmType algorithm) async {
    state = HomeState.loading();

    HashCrackingResult result = await _hashCracker.crack(hash, wordList, algorithm);
    state = HomeState.result(result);
  }

}

final homeStateStateNotifier = 
  StateNotifierProvider.autoDispose<HomeScreenStateNotifier, HomeState>((ref){
  
    final cracker = ref.watch(hashCrackerProvider);
    return HomeScreenStateNotifier(cracker);
  });

