import 'package:flut_crack/core/use_case.dart';
import 'package:flut_crack/features/wordlists/domain/repositories/word_list_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class RenameWordListUseCaseParams {
  final String currentName;
  final String newName;

  const RenameWordListUseCaseParams({
    required this.currentName,
    required this.newName,
  });
}

class RenameWordListUseCase extends 
  UseCase<RenameWordListUseCaseParams, Future<bool>> {
  
  final WordListRepository _repository;

  RenameWordListUseCase(this._repository);

  @override
  Future<bool> call(RenameWordListUseCaseParams params) async {
    return await _repository.renameWordList(
      params.currentName, 
      params.newName
    );
  }
}

final renameWordListUseCaseProvider = Provider((ref){
  final repo = ref.read(wordListRepositoryProvider);
  return RenameWordListUseCase(repo);
});