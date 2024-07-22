import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flut_crack/data/algorithm_type.dart';
import 'package:flut_crack/screens/providers/home_screen_state_notifier.dart';
import 'package:flut_crack/screens/providers/word_list_manager_provider.dart';
import 'package:flut_crack/utils/snackbar_utils.dart' show showErrorSnackBar;
import 'package:flut_crack/utils/theme_utils.dart' show colorSchemeOf;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flut_crack/widgets/nav_drawer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';


class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

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

  List<DropdownMenuItem<AlgorithmType>> _buildDropdownMenuItesm(){
    return AlgorithmType.values.map((AlgorithmType item) {
      return DropdownMenuItem<AlgorithmType>(
        value: item,
        child: Text(item.formattedName),
      );
    }).toList();
  }

  Widget _renderCrackingResult(BuildContext context, HomeState state){

    if(state.isLoading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final colorScheme = colorSchemeOf(context);
    final result = state.result;

    if(result != null){
      return Column(
        children: [
          Text(
            result.success
              ? result.matchedWord!
              : "Word not present in the selected wordlist",
            style: TextStyle(
              color: colorScheme.secondary
            )
          ),
          Text(
            "Tried ${result.triedWordsCount} words.",
            style: TextStyle(
              color: colorScheme.secondary
            )
          )
        ]
      );
    } else {
      return const Text(
        "Enter a hash to start",
        style: TextStyle(
          color: Colors.grey
        )
      );
    }
  }

  Future<void> _requestStoragePermission({
    required void Function() onGranted,
    required void Function() onDenied,
  }) async {

    if(!Platform.isAndroid) {
      onGranted();
      return;
    }

    final android = await DeviceInfoPlugin().androidInfo;
    if(android.version.sdkInt >= 33) {
      onGranted();
      return;
    }

    const permission = Permission.storage;

    if(await permission.isPermanentlyDenied){
      await openAppSettings();
    }

    if(await permission.isGranted){
      onGranted();
    } else {
      await permission
        .onDeniedCallback(onDenied)
        .onGrantedCallback(onGranted)
        .request();
    }

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colorScheme = colorSchemeOf(context);

    final hashTextController = useTextEditingController();
    final selectedAlgorithm = useState(AlgorithmType.unknown);
    final pickedFilePath = useState<String?>(null);

    final notifier = ref.read(homeStateStateNotifier.notifier);
    final state = ref.watch(homeStateStateNotifier);

    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("FlutCrack"),
        backgroundColor: colorScheme.primaryContainer,
      ),
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
              items: _buildDropdownMenuItesm(),
              onChanged: (type) => selectedAlgorithm.value = type ?? AlgorithmType.unknown,
              value: selectedAlgorithm.value,
            ),
            const SizedBox(height: 16),
            _renderCrackingResult(context, state),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await _requestStoragePermission(
                  onGranted: () async {
                    await _pickWordlistFile(
                        onSuccess: (platformFile) => pickedFilePath.value = platformFile.path,
                        onError: (error) => showErrorSnackBar(context, error)
                    );
                  },
                  onDenied: () => showErrorSnackBar(
                    context,
                    "Without storage permission can't load an external wordlist."
                  )
                );
              },
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

          if(selectedAlgorithm.value == AlgorithmType.unknown){
            showErrorSnackBar(context, "Please select a valid hashing algorithm.");
            return;
          }

          File? path = pickedFilePath.value != null
              ? File(pickedFilePath.value!)
              : null;
          final wordList = await ref.read(wordListManagerProvider).loadWordList(path);
          await notifier.crack(hashTextController.text, wordList, selectedAlgorithm.value);
        },
        child: const Icon(Icons.vpn_key),
      ),
    );
  }
}
