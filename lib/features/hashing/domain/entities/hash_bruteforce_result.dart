import 'package:flutter/foundation.dart';

@immutable
class HashBruteforceResult {
  final bool success;
  final int attempts;
  final String? matchedWord;

  const HashBruteforceResult.success({
    required this.attempts,
    required this.matchedWord
  }) : success = true;

  const HashBruteforceResult.failure({required this.attempts})
      : success = false,
        matchedWord = null;
}