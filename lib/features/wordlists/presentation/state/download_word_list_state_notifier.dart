import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:flut_crack/features/wordlists/domain/usecases/download_word_list_use_case.dart';

enum NetworkConcreteState {
  idle,
  downloading,
  downloadSuccess,
  downloadFailed
}

@immutable
class NetworkScreenState { 

  final NetworkConcreteState state;

  const NetworkScreenState({
    required this.state
  });

  const NetworkScreenState.downloading()
    : state = NetworkConcreteState.downloading;

  const NetworkScreenState.idle() 
    : state = NetworkConcreteState.idle;

  const NetworkScreenState.downloadFailed() 
    : state = NetworkConcreteState.downloadFailed;

  const NetworkScreenState.downloadSuccess() 
    : state = NetworkConcreteState.downloadSuccess;

}

class NetworkScreenNotifier extends StateNotifier<NetworkScreenState> {
  final DownloadWordListUseCase downloadWordListUseCase;

  NetworkScreenNotifier({
    required this.downloadWordListUseCase
  }) : super(const NetworkScreenState.idle());

  Future<void> downloadWordList(String link) async {
  try {
    state = const NetworkScreenState.downloading();
    final downloaded = await downloadWordListUseCase(link);

    if (downloaded) {
      state = const NetworkScreenState.downloadSuccess();
    } else {
      state = const NetworkScreenState.downloadFailed();
    }
  } catch (e) {
    state = const NetworkScreenState.downloadFailed();
  }
}

}

final downloadWordListScreenNotifierProvider = 
  StateNotifierProvider.autoDispose<NetworkScreenNotifier, NetworkScreenState>((ref){
    final downloadWordListUseCase = ref.read(downloadWordListUseCaseProvider);

    return NetworkScreenNotifier(
      downloadWordListUseCase: downloadWordListUseCase
    );
  });