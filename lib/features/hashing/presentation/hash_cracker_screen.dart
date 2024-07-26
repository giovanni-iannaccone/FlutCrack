import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flut_crack/core/algorithm_type.dart';
import 'package:flut_crack/features/hashing/presentation/state/hasher_provider.dart';
import 'package:flut_crack/features/hashing/presentation/state/home_screen_state_notifier.dart';
import 'package:flut_crack/features/wordlists/presentation/state/word_list_manager_provider.dart';
import 'package:flut_crack/core/utils/snackbar_utils.dart' show showErrorSnackBar, showSnackBar;
import 'package:flut_crack/common_widgets/dialog_widget.dart';
import 'package:flut_crack/common_widgets/hash_algorithm_selector.dart';
import 'package:flut_crack/common_widgets/result_card.dart';
import 'package:flutter/material.dart';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class HashCrackerScreen extends HookConsumerWidget {
  const HashCrackerScreen({super.key});

  Future<void> _pickWordlistFile({
    required void Function(XFile) onSuccess,
    required void Function(String error) onError,
    required wordListManager
  }) async {

    const XTypeGroup typeGroup = XTypeGroup(
      label: 'text',
      extensions: <String>['txt'],
    );

    try {
      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
        initialDirectory: await wordListManager.localPath
      );
  
      if(result == null){
        return;
      }

      if (result.toString().isEmpty) {
        onError("An error occured during file picking!");
      } else {
        onSuccess(result);
      }
    } on Exception catch(ex) {
      onError(ex.toString());
    }
  }

  Widget _renderBasedOnState(BuildContext context, HomeState state){
    switch(state){
      case HomeStateIdle():
        return const Text(
          "Enter a hash to start", 
          style: TextStyle(
            color: Colors.grey
          )
        );
      case HomeStateLoading():
        return const Center(
          child: CircularProgressIndicator(),
        );
      case HomeStateSuccess(:final matchedWord, :final attempts):
        return ResultCard(
          title: matchedWord,
          subtitle: "Match found after $attempts attempts.",
          onCopyPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: matchedWord)
            );

            if(context.mounted){
              showSnackBar(context, "Result copied into clipboard.");
            }
          },
        );
      case HomeStateError(:final message):
        return ResultCard(
          error: true,
          title: message
        );
    }
  }

  Future<void> _requestPermission({
    required Permission permission,
    required void Function() onGranted,
    required void Function() onDenied,
  }) async{

    if(!Platform.isAndroid) {
      onGranted();
      return;
    }

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if(androidInfo.version.sdkInt >= 33){
      onGranted();
      return;
    }

    if(await permission.isPermanentlyDenied){
      await openAppSettings();
    }

    if(await permission.isGranted) {
      onGranted();
      return;
    } else {

      if (await permission.request().isGranted) {
        onGranted();
      } else {
        onDenied();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final hashTextController = useTextEditingController();
    final pickedFilePath = useState<String?>(null);
    final selectedAlgorithm = useState(AlgorithmType.unknown);

    final wordListManager = ref.read(wordListManagerProvider);
    final notifier = ref.read(homeStateStateNotifier.notifier);
    final state = ref.watch(homeStateStateNotifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: hashTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter your hash",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            HashAlgorithmSelector(
              label: "Select hash algorithm",
              onChanged: (type) => selectedAlgorithm.value = type ?? AlgorithmType.unknown,
              value: selectedAlgorithm.value,
            ),
            const SizedBox(height: 16),
            _renderBasedOnState(context, state),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogWidget(
                    context: context,
                    
                    onFilePick: () async => await _requestPermission(
                      permission: Permission.storage, 
                      onGranted: () => _pickWordlistFile(
                        onSuccess: (file) => pickedFilePath.value = file.path,
                        onError: (error) => showErrorSnackBar(context, error),
                        wordListManager: wordListManager
                      ), 
                      onDenied: () {
                        if(context.mounted){
                          showErrorSnackBar(
                            context, 
                            "Without storage permission can't load an external wordlist."
                          );
                        }
                      }
                    ),
                    onWordListPick: () => {}
                  );
                }
              ),
              icon: const Icon(Icons.folder_open),
              label: Text(pickedFilePath.value ?? "Pick a wordlist"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async { 
          
          final hash = hashTextController.text.trim();
          AlgorithmType algorithmType = selectedAlgorithm.value;

          if(algorithmType == AlgorithmType.unknown) {
            algorithmType = ref.read(hasherProvider).indentifyAlgorithm(hash);

            if(algorithmType == AlgorithmType.unknown){

              if(!context.mounted) return;

              showErrorSnackBar(context, "Unable to detect the hashing alogrithm.");
              return;
            }
          }
          
          File? path = pickedFilePath.value != null
            ? File(pickedFilePath.value!)
            : null;

          final wordList = await wordListManager.loadWordList(path!);
          await notifier.crackHash(hash, wordList, algorithmType);        
        },
        child: const Icon(Icons.vpn_key),
      ),
    );
  }
}
