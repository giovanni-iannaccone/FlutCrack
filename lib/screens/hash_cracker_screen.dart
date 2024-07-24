import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flut_crack/data/algorithm_type.dart';
import 'package:flut_crack/screens/providers/home_screen_state_notifier.dart';
import 'package:flut_crack/screens/providers/word_list_manager_provider.dart';
import 'package:flut_crack/utils/build_dropdown_utils.dart';
import 'package:flut_crack/utils/hash_utils.dart';
import 'package:flut_crack/utils/snackbar_utils.dart' show showErrorSnackBar, showSnackBar;
import 'package:flut_crack/widgets/result_card.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class HashCrackerScreen extends HookConsumerWidget {
  const HashCrackerScreen({super.key});

  Future<void> _pickWordlistFile({
    required void Function(PlatformFile) onSuccess,
    required void Function(String error) onError,
  }) async {

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if(result == null){
        return;
      }

      if (result.files.isNotEmpty) {
        onSuccess(result.files.first);
      } else {
        onError("An error occured during file picking!");
      }
    } on Exception catch(ex) {
      onError(ex.toString());
    }
  }

  Widget _renderCrackingResult(BuildContext context, HomeState state){

    if(state.isLoading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final result = state.result;

    if(result != null){
      return ResultCard(
        error: !result.success,
        title: result.success
          ? result.matchedWord!
          : "No match found, try another word list.",
        subtitle: "Tried ${result.triedWordsCount} words.",
        onCopyPressed: () async {
          Clipboard.setData(
            ClipboardData(text: result.matchedWord!)
          );

          if(context.mounted){
            showSnackBar(context, "Hash copied into clipboard.");
          }
        },
      );
    }

    return const Text(
      "Enter a hash to start", 
      style: TextStyle(
        color: Colors.grey
      )
    );
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
                labelText: 'Enter your hash',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AlgorithmType>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Hash Algorithm',
              ),
              items: buildDropdownMenuItems(),
              onChanged: (type) => selectedAlgorithm.value = type ?? AlgorithmType.unknown,
              value: selectedAlgorithm.value,
            ),
            const SizedBox(height: 16),
            _renderCrackingResult(context, state),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async => await _requestPermission(
                permission: Permission.storage, 
                onGranted: () => _pickWordlistFile(
                  onSuccess: (platformFile) => pickedFilePath.value = platformFile.path,
                  onError: (error) => showErrorSnackBar(context, error)
                ), 
                onDenied: (){
                  if(context.mounted){
                    showErrorSnackBar(
                      context, 
                      "Without storage permission can't load an external wordlist."
                    );
                  }
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
            algorithmType = hashIdentifying(hash);

            if(algorithmType == AlgorithmType.unknown){

              if(!context.mounted) return;

              showErrorSnackBar(context, "Unable to detect the hashing alogrithm.");
              return;
            }
          }
          
          File? path = pickedFilePath.value != null
            ? File(pickedFilePath.value!)
            : null;

          final wordList = await ref.read(wordListManagerProvider).loadWordList(path);
          await notifier.crack(hash, wordList, algorithmType);        
        },
        child: const Icon(Icons.vpn_key),
      ),
    );
  }
}
