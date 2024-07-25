import 'package:flut_crack/data/hash_bruteforcer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hashBruteforceProvider = Provider<HashBruteforcer>((ref){
  return HashBruteforcer();
});