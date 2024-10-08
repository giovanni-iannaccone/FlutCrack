import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class WordListManager {
  
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile(String name) async {
    final path = await localPath;
    return File("$path/$name");
  }

  Future<void> createNewWordList(String name) async {
    final file = await _getLocalFile(name);
    await file.create();
  }

  Future<void> deleteWordList(String path) async {
    final file = File(path);
    await file.delete();
  }

  Future<List<String>> getWordListsNames() async {
    final directory = Directory(await localPath);

    return await directory.list(recursive: false)
      .where((entity) => entity is File)
      .map((entity) => entity.path)
      .toList();
  }

  Future<void> addWordsToWordList(String name, List<String> words) async {
    final file = await _getLocalFile(name);

    await file.writeAsString(
      words.join('\n'), 
      mode: FileMode.append
    );
  }

  Future<List<String>> loadWordList(String filePath) async {
    try {
      var file = File(filePath);    
      return await file.readAsLines();
    } catch(e) {
      var file = await _getLocalFile(filePath);
      return file.readAsLines();
    }
  }

  Future<void> renameWordList(String oldName, String newName) async {
    final path = await localPath;
    final file = await _getLocalFile(oldName);

    await file.rename("$path/$newName");
  }
}

final wordListManagerProvider = Provider<WordListManager>((ref){
  return WordListManager();
});