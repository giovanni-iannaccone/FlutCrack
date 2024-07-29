import 'package:flut_crack/core/data/word_list_manager.dart';
import 'package:flut_crack/core/use_case.dart';

class LoadWordListUseCase extends UseCase<String, Future<List<String>>> {

  final WordListManager _wordListManager;

  LoadWordListUseCase(this._wordListManager);

  @override
  Future<List<String>> call(String params) async {
    return await _wordListManager.loadWordList(params);
  }
}