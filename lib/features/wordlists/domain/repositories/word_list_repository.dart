import 'package:flut_crack/shared/data/word_list_manager.dart';
import 'package:flut_crack/features/wordlists/data/repositories/word_list_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class WordListRepository {
  Future<List<String>> getAllWordListsNames();

  Future<bool> createEmptyWordList(String name);
  Future<bool> deleteWordList(String name);
  Future<bool> renameWordList(String currentName, String newName);
  Future<bool> appendWordsTo(String wordListName, List<String> words);
}

final wordListRepositoryProvider = Provider((ref){
  final manager = ref.read(wordListManagerProvider);
  return WordListRepositoryImpl(manager);
});