import 'package:flut_crack/components/card.dart';
import 'package:flut_crack/utils/hash_utils.dart';
import 'package:flut_crack/data/algorithm_type.dart';
import 'package:flut_crack/utils/build_dropdown_utils.dart';

import 'package:flutter/material.dart';
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
            const SizedBox(height: 16),
            if (result.value != null)
              buildCard(result.value!, null)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedAlgorithm.value == AlgorithmType.unknown) {
            result.value = "Use a valid algorithm";
          } else {
            result.value = calculateHash(hashTextController.text, selectedAlgorithm.value);
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}