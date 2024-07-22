import 'dart:io';
import 'package:path_provider/path_provider.dart';

const String defaultDictionaryName = "FlutCrackDictionary.txt";

class WordListManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  } 

  Future<void> clearDefaultWordList() async {
    final path = await _localPath;
    File file = File('$path/FlutCrackDictionary.txt');
    await file.writeAsString('');
  }

  Future<List<String>> loadWordList([File? dictionaryPath]) async {
    final path = await _localPath;
    final file = dictionaryPath ?? File("$path/$defaultDictionaryName");

    return await file.readAsLines();
  }

  Future<void> addWordsToDefaultWordList(List<String> words) async {
    final path = await _localPath;
    File file = File("$path/$defaultDictionaryName");
    file.writeAsString(words.join('\n'), mode: FileMode.append);
  }
}