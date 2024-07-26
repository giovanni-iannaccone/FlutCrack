import 'package:flut_crack/data/word_list_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getWordListsProvider = FutureProvider<List<String>>((ref) async {
  return WordListManager().getDictionariesNames();
});

final searchBarProvider = StateProvider<String>((ref) => '');