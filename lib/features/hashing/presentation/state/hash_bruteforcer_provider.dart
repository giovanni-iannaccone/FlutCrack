import 'package:flut_crack/core/hash_bruteforcer.dart';
import 'package:flut_crack/features/hashing/presentation/state/hasher_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hashBruteforceProvider = Provider<HashBruteforcer>((ref){
  final hasher = ref.read(hasherProvider);
  return HashBruteforcer(hasher);
});