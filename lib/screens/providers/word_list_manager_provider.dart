import 'package:flut_crack/data/word_list_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordListManagerProvider = Provider<WordListManager>((ref){
  return WordListManager();
});