import 'package:flut_crack/features/hashing/presentation/state/hasher_provider.dart';
import 'package:flut_crack/core/utils/snackbar_utils.dart';
import 'package:flut_crack/common_widgets/hash_algorithm_selector.dart';
import 'package:flut_crack/common_widgets/result_card.dart';
import 'package:flut_crack/core/algorithm_type.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HasherScreen extends HookConsumerWidget {
  const HasherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hashTextController = useTextEditingController();
    final result = useState<String?>(null);
    final selectedAlgorithm = useState(AlgorithmType.unknown);

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
                labelText: 'Enter your word',
                prefixIcon: Icon(Icons.abc),
              ),
            ),
            const SizedBox(height: 16),
            HashAlgorithmSelector(
              label: "Select hash algorithm",
              onChanged: (type) => selectedAlgorithm.value = type ?? AlgorithmType.unknown,
              value: selectedAlgorithm.value,
            ),
            const SizedBox(height: 32),
            if (result.value != null) ResultCard(
              title: result.value!,
              onCopyPressed: () async {
                await Clipboard.setData(ClipboardData(text: result.value!));
                
                if(context.mounted){
                  showSnackBar(context, "Hash copied into clipboard.");
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedAlgorithm.value == AlgorithmType.unknown) {
            showErrorSnackBar(context, "Choose an hashing alogrithm.");
            return;
          }
          
          result.value = ref.read(hasherProvider).calculateHash(
            hashTextController.text.trim(), 
            selectedAlgorithm.value
          );
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}