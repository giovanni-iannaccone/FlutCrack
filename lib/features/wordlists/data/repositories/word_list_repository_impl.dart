import 'dart:io';

import 'package:flut_crack/core/utils/http_utils.dart';
import 'package:flut_crack/shared/data/word_list_manager.dart';
import 'package:flut_crack/features/wordlists/domain/repositories/word_list_repository.dart';

class WordListRepositoryImpl implements WordListRepository {

  final WordListManager _wordListManager;

  WordListRepositoryImpl(this._wordListManager);

  @override
  Future<bool> appendWordsTo(String wordListName, List<String> words) async {
    await _wordListManager.addWordsToWordList(wordListName, words);
    return true;
  }

  @override
  Future<bool> deleteWordList(String name) async {
    try {
      await _wordListManager.deleteWordList(name);
    } on FileSystemException {
      return false;
    }

    return true;
  }

  @override
  Future<List<String>> getAllWordListsNames() async {
    return await _wordListManager.getWordListsNames();
  }

  @override
  Future<bool> downloadWordList(String link) async {
    final String wordListName = link.split('/').last;
    final String? response = await getURLContent(link);
    
    if (response != null ) {
      List<String> words = response.split('\n');

      return 
        await createEmptyWordList(wordListName) & 
        await appendWordsTo(wordListName, words);

    }

    return false;
  }

  @override
  Future<bool> renameWordList(String currentName, String newName) async {
    try{
      await _wordListManager.renameWordList(currentName, newName);
    } on FileSystemException  {
      return false;
    }

    return true;
  }
  
  @override
  Future<bool> createEmptyWordList(String name) async {
    await _wordListManager.createNewWordList(name);
    return true;
  }
}