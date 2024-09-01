import 'dart:io';

import 'package:flut_crack/app_routes.dart' as routes;
import 'package:flut_crack/core/utils/navigation_utils.dart';
import 'package:flut_crack/core/utils/snackbar_utils.dart';
import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/features/hashing/presentation/state/hash_cracker_screen_state_notifier.dart';
import 'package:flut_crack/features/hashing/presentation/widgets/result_card.dart';
import 'package:flut_crack/features/hashing/presentation/widgets/dialog_widget.dart';
import 'package:flut_crack/features/hashing/presentation/widgets/hash_algorithm_selector.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class HashCrackerScreen extends HookConsumerWidget {
  const HashCrackerScreen({super.key});

  Future<void> _pickWordListFile({
    required void Function(XFile) onSuccess,
    required void Function(String error) onError,
  }) async {

    const XTypeGroup typeGroup = XTypeGroup(
      label: 'text',
      extensions: ['txt'],
    );

    try {
      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup]
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

  Widget _renderBasedOnState(BuildContext context, HashCrackerScreenState state){
    switch(state){
      case HashCrackerScreenStateIdle():
        return const Text(
          "Enter a hash to start", 
          style: TextStyle(
            color: Colors.grey
          )
        );
      case HashCrackerScreenStateLoading():
        return const Center(
          child: CircularProgressIndicator(),
        );
      case HashCrackerScreenStateSuccess(:final matchedWord, :final attempts):
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
      case HashCrackerScreenStateError(:final message):
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
    final selectedAlgorithm = useState(HashAlgorithmType.unknown);

    final notifier = ref.read(hashCrackerScreenNotifier.notifier);
    final state = ref.watch(hashCrackerScreenNotifier);

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
              onChanged: (type) => selectedAlgorithm.value = type ?? HashAlgorithmType.unknown,
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
                    onFilePick: () async => await _requestPermission(
                      permission: Permission.storage, 
                      onGranted: () async => _pickWordListFile(
                        onSuccess: (file) => pickedFilePath.value = file.path,
                        onError: (error) => showErrorSnackBar(context, error)
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
                    onWordListPick: () async => await navigateTo(
                      context, 
                      routes.wordListChoice, 
                      arguments: pickedFilePath
                    ),
                    onNetworkPick: () async => await navigateTo(
                      context,
                      routes.networkWordListChoice,
                      arguments: pickedFilePath
                    )
                  );
                }
              ),
              icon: const Icon(Icons.folder_open),
              label: Text((pickedFilePath.value ?? "Pick a wordlist").split('/').last),
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
          HashAlgorithmType algorithmType = selectedAlgorithm.value;

          if(algorithmType == HashAlgorithmType.unknown) {
            algorithmType = notifier.identifyHash(hash);
            selectedAlgorithm.value = algorithmType;
            
            if(algorithmType == HashAlgorithmType.unknown){

              if(!context.mounted) return;

              showErrorSnackBar(context, "Unable to detect the hashing algorithm.");
              return;
            }
          }

          if(pickedFilePath.value == null){
            showErrorSnackBar(context, "Choose a word list.");
            return;
          }

          notifier.crackHash(hash, pickedFilePath.value!, algorithmType);        
        },
        child: const Icon(Icons.vpn_key),
      ),
    );
  }
}
