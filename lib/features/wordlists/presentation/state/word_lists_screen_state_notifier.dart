import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/wordlists/domain/usecases/create_word_list_use_case.dart';
import 'package:flut_crack/features/wordlists/domain/usecases/delete_word_list_use_case.dart';
import 'package:flut_crack/features/wordlists/domain/usecases/get_word_lists_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WordListConcreteState {
  loading,
  loaded,
  wordListCreated,
  unableToDeleteWordList,
  wordListDeleted,
  unableToCreateWordList
}

@immutable
class WordListsScreenState { 

  final WordListConcreteState state;
  final List<String> wordLists;  

  const WordListsScreenState({
    required this.state,
    this.wordLists = const []
  });

  const WordListsScreenState.loading() 
    : state = WordListConcreteState.loading,
      wordLists = const [];
    
  const WordListsScreenState.loaded(this.wordLists) 
    : state = WordListConcreteState.loaded;

  const WordListsScreenState.deleteWordListFail(this.wordLists) 
    : state = WordListConcreteState.unableToDeleteWordList;

  const WordListsScreenState.deleteWordListSuccess(this.wordLists) 
    : state = WordListConcreteState.wordListDeleted;

  const WordListsScreenState.createWordListSuccess(this.wordLists) 
    : state = WordListConcreteState.wordListCreated;

  const WordListsScreenState.createWordListFail(this.wordLists) 
    : state = WordListConcreteState.unableToCreateWordList;

}


class WordListsScreenNotifier extends StateNotifier<WordListsScreenState> {
  
  final DeleteWordListUseCase deleteWordListUseCase;
  final GetWordListsUseCase getWordListsUseCase;
  final CreateWordListUseCase createWordListUseCase;

  WordListsScreenNotifier({
    required this.deleteWordListUseCase,
    required this.getWordListsUseCase,
    required this.createWordListUseCase
  }) : super(const WordListsScreenState.loading()) {
    loadWordListsName();
  }

  Future<void> deleteWordList(String name) async {
    final wordLists = state.wordLists;

    state = const WordListsScreenState.loading();

    final deleted = await deleteWordListUseCase(name);

    if(deleted) {
      wordLists.remove(name);
      state = WordListsScreenState.deleteWordListSuccess(wordLists);
    } else {
      state = WordListsScreenState.deleteWordListFail(wordLists);
    }
  }

  Future<void> createWordList() async {
    
    final wordLists = state.wordLists;

    state = const WordListsScreenState.loading();

    final fileName = _generateWordListName();
    final created = await createWordListUseCase(fileName);

    if(created) {
      wordLists.add(fileName);
      state = WordListsScreenState.createWordListSuccess(wordLists);
    } else {
      state = WordListsScreenState.createWordListFail(wordLists);
    }
  }

  Future<void> filterWordLists(String query) async {

    final wordLists = await _fetchWordListNames();

    if(query.isEmpty) {
      state = WordListsScreenState.loaded(wordLists);
    } else {
      state = WordListsScreenState.loaded(
        wordLists
          .where((wordList) => 
            wordList
              .toLowerCase()
              .contains(query.toLowerCase())
          )
          .toList()
      );
    }
  }

  Future<List<String>> _fetchWordListNames() async 
    => await getWordListsUseCase(UseCaseNoParams());

  Future<void> loadWordListsName() async {
    state = const WordListsScreenState.loading();
    final wordLists = await _fetchWordListNames();

    state = WordListsScreenState.loaded(wordLists);
  }

  String _generateWordListName(){
    final today = DateTime.now().toString();
    return "wordlist-$today.txt";
  }
}


final wordListsScreenNotifierProvider = 
  StateNotifierProvider.autoDispose<WordListsScreenNotifier, WordListsScreenState>((ref){
    
    final deleteWordListUseCase = ref.read(deleteWordListUseCaseProvider);
    final getWordListsUseCase = ref.read(getWordListsUseCaseProvider);
    final createWordListUseCase = ref.read(createWordListUseCaseProvider);

    return WordListsScreenNotifier(
      deleteWordListUseCase: deleteWordListUseCase, 
      getWordListsUseCase: getWordListsUseCase, 
      createWordListUseCase: createWordListUseCase
    );
  });