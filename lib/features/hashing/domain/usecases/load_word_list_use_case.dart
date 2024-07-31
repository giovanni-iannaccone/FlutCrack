import 'package:flut_crack/shared/data/word_list_manager.dart';
import 'package:flut_crack/core/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadWordListUseCase extends UseCase<String, Future<List<String>>> {

  final WordListManager _wordListManager;

  LoadWordListUseCase(this._wordListManager);

  @override
  Future<List<String>> call(String params) async {
    return await _wordListManager.loadWordList(params);
  }
}

final loadWordListUseCaseProvider = Provider((ref){
  final wordListManager = ref.read(wordListManagerProvider);
  return LoadWordListUseCase(wordListManager);
});