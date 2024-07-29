import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class WordListManager {

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String name) async {
    final path = await localPath;
    return File("$path/$name");
  }

  Future<void> createNewWordList(String name) async {
    final file = await _getFile(name);
    await file.create();
  }

  Future<void> deleteWordList(String name) async {
    final file = await _getFile(name);
    await file.delete();
  }

  Future<List<String>> getWordListsNames() async {
    final directory = Directory(await localPath);

    return await directory.list(recursive: false)
      .where((entity) => entity is File)
      .map((entity) => entity.path.split('/').last)
      .toList();
  }

  Future<void> addWordsToWordList(String name, List<String> words) async {
    final file = await _getFile(name);

    await file.writeAsString(
      words.join('\n'), 
      mode: FileMode.append
    );
  }

  Future<List<String>> loadWordList(String name) async {
    final file = await _getFile(name);
    return await file.readAsLines();
  }

  Future<void> renameWordList(String oldName, String newName) async {
    final path = await localPath;
    final file = await _getFile(oldName);

    await file.rename("$path/$newName");
  }
}

final wordListManagerProvider = Provider<WordListManager>((ref){
  return WordListManager();
});