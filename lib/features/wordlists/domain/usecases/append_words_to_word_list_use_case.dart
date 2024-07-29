
import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/wordlists/domain/repositories/word_list_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AppendWordsToWordListUseCaseParams {
  final String wordListName;
  final List<String> newWords;

  const AppendWordsToWordListUseCaseParams({
    required this.wordListName,
    required this.newWords
  });
}

class AppendWordToWordListUseCase extends
  UseCase<AppendWordsToWordListUseCaseParams, Future<bool>> {

  final WordListRepository _repository;

  AppendWordToWordListUseCase(this._repository);

  @override
  Future<bool> call(AppendWordsToWordListUseCaseParams params) async {
    return await _repository.appendWordsTo(
      params.wordListName,
      params.newWords
    );
  }
}

final appendWordsToWordListUseCaseProvider = Provider((ref){
  final repo = ref.read(wordListRepositoryProvider);
  return AppendWordToWordListUseCase(repo);
});