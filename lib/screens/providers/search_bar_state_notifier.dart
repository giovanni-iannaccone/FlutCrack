import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBarController extends StateNotifier<List> {
  SearchBarController() : super([]);

  void onSearchWordList(String query, List<dynamic> data) {
    state = [];
    if (query.isNotEmpty) {
      final result = data
          .where((element) => element
              .toString()
              .contains(query.toString()))
          .toList();

      state.addAll(result);
    }
  }
}