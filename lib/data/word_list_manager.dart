import 'dart:io';
import 'package:path_provider/path_provider.dart';

const String defaultDictionaryName = "FlutCrackDictionary.txt";

class WordListManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  } 

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/$defaultDictionaryName");
  }

  Future<void> clearDefaultWordList() async {
    final file = await _localFile;
    file.writeAsString('');
  }

  Future<List<String>> loadWordList([File? dictionaryPath]) async {
    final file = dictionaryPath ?? await _localFile;
    return await file.readAsLines();
  }

  Future<void> addWordsToDefaultWordList(List<String> words) async {
    final file = await _localFile;
    file.writeAsString(words.join('\n'), mode: FileMode.append);
  }
}