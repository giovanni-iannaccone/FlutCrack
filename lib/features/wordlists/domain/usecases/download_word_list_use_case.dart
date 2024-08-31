import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/wordlists/domain/repositories/word_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadWordListUseCase extends
  UseCase<String, Future<bool>> {

  final WordListRepository _repository;

  DownloadWordListUseCase(this._repository);

  @override
  Future<bool> call(String params) async {
    return await _repository.downloadWordList(params);
  }
}

final downloadWordListUseCaseProvider = Provider((ref){
  final repo = ref.read(wordListRepositoryProvider);
  return DownloadWordListUseCase(repo);
});