import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/wordlists/domain/repositories/word_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetWordListsUseCase extends 
  UseCase<UseCaseNoParams, Future<List<String>>> {

  final WordListRepository _repository;

  GetWordListsUseCase(this._repository);


  @override
  Future<List<String>> call(UseCaseNoParams params) async {
    return _repository.getAllWordListsNames();  
  }
}

final getWordListsUseCaseProvider = Provider((ref){
  final repo = ref.read(wordListRepositoryProvider);
  return GetWordListsUseCase(repo);
});