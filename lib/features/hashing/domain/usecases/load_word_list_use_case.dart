import 'dart:io';

import 'package:flut_crack/shared/data/word_list_manager.dart';
import 'package:flut_crack/core/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadWordListUseCase extends UseCase<String, Future<List<String>>> {

  final WordListManager _wordListManager;

  LoadWordListUseCase(this._wordListManager);

  @override
  Future<List<String>> call(String params) async {
    final isLocal = File(params).path == await _wordListManager.localPath;

    return isLocal
      ? await _wordListManager.loadLocalWordList(params)
      : await _wordListManager.loadExternalWordList(params);
  }
}

final loadWordListUseCaseProvider = Provider((ref){
  final wordListManager = ref.read(wordListManagerProvider);
  return LoadWordListUseCase(wordListManager);
});