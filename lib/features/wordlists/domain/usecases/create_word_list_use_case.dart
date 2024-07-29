import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/wordlists/domain/repositories/word_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateWordListUseCase extends UseCase<String, Future<bool>> {

  final WordListRepository _repository;

  CreateWordListUseCase(this._repository);

  @override
  Future<bool> call(String params) async {
    return await _repository.createEmptyWordList(params);
  }
}


final createWordListUseCaseProvider = Provider((ref){
  final repo = ref.read(wordListRepositoryProvider);
  return CreateWordListUseCase(repo);
});