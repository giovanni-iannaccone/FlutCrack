import 'package:flut_crack/features/wordlists/domain/usecases/append_words_to_word_list_use_case.dart';
import 'package:flut_crack/features/wordlists/domain/usecases/rename_word_list_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum EditScreenState {
  idle,
  renameSuccess,
  renameFail,
  appendWordsSuccess,
  appendWordsFail
}

class EditWordListScreenNotifier extends StateNotifier<EditScreenState> {
  
  final RenameWordListUseCase renameWordListUseCase;
  final AppendWordToWordListUseCase appendWordToWordListUseCase;

  EditWordListScreenNotifier({
    required this.appendWordToWordListUseCase,
    required this.renameWordListUseCase
  }) : super(EditScreenState.idle);

  Future<void> renameWordList(String currentName, String newName) async {
    final renamed = await renameWordListUseCase(
      RenameWordListUseCaseParams(
        currentName: currentName, 
        newName: newName
      )
    );

    renamed
      ? EditScreenState.renameSuccess
      : EditScreenState.renameFail;
  }

  Future<void> appendWordsToWordList(String name, List<String> words) async {
    final added = await appendWordToWordListUseCase(
      AppendWordsToWordListUseCaseParams(
        wordListName: name, 
        newWords: words
      )
    );

    added
      ? EditScreenState.appendWordsSuccess
      : EditScreenState.appendWordsFail;
  }

}

final editWordListScreenNotifierProvider = 
  StateNotifierProvider.autoDispose<EditWordListScreenNotifier, EditScreenState>((ref){
    final renameWordListUseCase = ref.read(renameWordListUseCaseProvider);
    final appendWordToWordListUseCase = ref.read(appendWordsToWordListUseCaseProvider);

    return EditWordListScreenNotifier(
      appendWordToWordListUseCase: appendWordToWordListUseCase, 
      renameWordListUseCase: renameWordListUseCase
    );
  });