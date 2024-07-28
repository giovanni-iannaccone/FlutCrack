import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flut_crack/core/utils/snackbar_utils.dart';
import 'package:flut_crack/features/hashing/presentation/state/hasher_screen_state_notifier.dart';
import 'package:flut_crack/features/hashing/presentation/widgets/hash_algorithm_selector.dart';
import 'package:flut_crack/features/hashing/presentation/widgets/result_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HasherScreen extends HookConsumerWidget {
  const HasherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hashTextController = useTextEditingController();
    final selectedAlgorithm = useState(HashAlgorithmType.unknown);

    final notifier = ref.read(hasherScreenStateNotifier.notifier);
    final result = useState<String?>(null);

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
              onChanged: (type) => selectedAlgorithm.value = type ?? HashAlgorithmType.unknown,
              value: selectedAlgorithm.value,
            ),
            const SizedBox(height: 32),
            (result.value == null)
              ? const Text(
                "Enter a hash to start",
                style: TextStyle(
                  color: Colors.grey
                )
              )
              : ResultCard(
                title: result.value!,
                onCopyPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: result.value!)
                  );

                  if (context.mounted) {
                    showSnackBar(context, "Hash copied into clipboard.");
                  }
                },
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedAlgorithm.value == HashAlgorithmType.unknown) {
            showErrorSnackBar(context, "Choose an hashing algorithm.");
            return;
          }

          result.value = notifier.calculateHash(
            hashTextController.text.trim(),
            selectedAlgorithm.value
          );
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
