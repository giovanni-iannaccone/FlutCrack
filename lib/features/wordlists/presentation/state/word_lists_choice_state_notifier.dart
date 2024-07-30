import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flut_crack/shared/data/word_list_manager.dart';

class WordListsState {
  final List<String> wordLists;
  final List<String> filteredWordLists;
  final bool isLoading;

  WordListsState({
    required this.wordLists,
    required this.filteredWordLists,
    required this.isLoading,
  });

  WordListsState copyWith({
    List<String>? wordLists,
    List<String>? filteredWordLists,
    bool? isLoading,
  }) {
    return WordListsState(
      wordLists: wordLists ?? this.wordLists,
      filteredWordLists: filteredWordLists ?? this.filteredWordLists,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WordListsNotifier extends StateNotifier<WordListsState> {
  WordListsNotifier() : super(WordListsState(wordLists: [], filteredWordLists: [], isLoading: true)) {
    _loadWordLists();
  }

  Future<void> _loadWordLists() async {
    await Future.delayed(const Duration(seconds: 1));
    final wordLists = await  WordListManager().getWordListsNames();
    state = state.copyWith(wordLists: wordLists, filteredWordLists: wordLists, isLoading: false);
  }

  void filterWordLists(String searchText) {
    final filtered = state.wordLists.where((wordList) {
      return wordList.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    state = state.copyWith(filteredWordLists: filtered);
  }
}

final wordListsNotifierProvider = StateNotifierProvider<WordListsNotifier, WordListsState>((ref) {
  return WordListsNotifier();
});
