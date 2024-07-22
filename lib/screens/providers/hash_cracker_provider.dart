import 'package:flut_crack/data/hash_cracker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hashCrackerProvider = Provider<HashCracker>((ref){
  return HashCracker();
});