import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WordListManager {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> createNewWordlist(String wordList) async {
    final directory = await localPath;
    File newWordList = File("$directory/$wordList");
    newWordList.create();
  }

  Future<void> deleteWordlist(String wordList) async {
    final directory = await localPath;
    File removableWordList = File("$directory/$wordList");
    removableWordList.delete();
  }

  Future<List<String>> getDictionariesNames() async {
    List<String> fileList = [];
    Directory dir = Directory(await localPath);

    await for (var file in dir.list(recursive: false)) {
      if (file is File) {
        fileList.add(file.path.split('/').last);
      }
    }

    return fileList;
  }

  Future<void> addWordsToWordList(String wordlist, List<String> words) async {
    final directory = await localPath;
    File file = File("$directory/$wordlist");
    file.writeAsString(words.join('\n'), mode: FileMode.append);
  }

  Future<void> deleteWordList(String wordlist) async {
    final directory = await localPath;
    File file = File("$directory/$wordlist");
    file.delete();
  }

  Future<List<String>> loadWordList(File dictionaryPath) async {
    final file = dictionaryPath;
    return await file.readAsLines();
  }

  Future<void> renameWordList(String oldName, String newName) async {
    final directory = await localPath;
    File oldFile = File("$directory/$oldName");
    String newFile = "$directory/$newName";
    oldFile.rename(newFile);
  }
}