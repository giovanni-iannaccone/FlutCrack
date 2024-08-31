import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flut_crack/features/wordlists/domain/usecases/download_word_list_use_case.dart';

enum NetworkScreenState {
  idle,
  downloadSuccess,
  downloadFailed
}

class NetworkScreenNotifier extends StateNotifier<NetworkScreenState> {
  final DownloadWordListUseCase downloadWordListUseCase;

  NetworkScreenNotifier({
    required this.downloadWordListUseCase
  }) : super(NetworkScreenState.idle);

  Future<void> downloadWordList(String link) async {
    final downloaded = await downloadWordListUseCase(link);

    downloaded == true
      ? NetworkScreenState.downloadSuccess
      : NetworkScreenState.downloadFailed;
  }
}

final downloadWordListScreenNotifierProvider = 
  StateNotifierProvider.autoDispose<NetworkScreenNotifier, NetworkScreenState>((ref){
    final downloadWordListUseCase = ref.read(downloadWordListUseCaseProvider);

    return NetworkScreenNotifier(
      downloadWordListUseCase: downloadWordListUseCase
    );
  });