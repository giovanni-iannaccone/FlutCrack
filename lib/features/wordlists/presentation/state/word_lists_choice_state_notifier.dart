import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/wordlists/domain/usecases/get_word_lists_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WordListsNotifier extends StateNotifier<List<String>> {
  
  final GetWordListsUseCase getWordListsUseCase;
  
  WordListsNotifier(this.getWordListsUseCase) : super([]) {
    _fetchWordLists();
  }

  Future<void> _fetchWordLists() async {
    state = await getWordListsUseCase(UseCaseNoParams());
  }

  Future<void> filterWordLists(String query) async {
    if(query.isEmpty){
      await _fetchWordLists();
      return;
    }

    state = state
      .where((wordList) => 
        wordList
          .toLowerCase()
          .contains(query.toLowerCase())
      )
      .toList();
  }
}

final wordListsNotifierProvider = 
  StateNotifierProvider.autoDispose<WordListsNotifier, List<String>>((ref) {
    final getWordListsUseCase = ref.read(getWordListsUseCaseProvider);
    return WordListsNotifier(getWordListsUseCase);
  });