import 'package:flut_crack/features/hashing/domain/entities/hash_algorithm_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HashAlgorithmSelector extends HookWidget {

  final String label;
  final void Function(HashAlgorithmType?)? onChanged;
  final HashAlgorithmType? value;

  const HashAlgorithmSelector({
    super.key,
    required this.label,
    this.value,
    this.onChanged
  });

  List<DropdownMenuItem<HashAlgorithmType>> _buildDropdownMenuItems(){
    return HashAlgorithmType.values.map((HashAlgorithmType item) {
      return DropdownMenuItem<HashAlgorithmType>(
        value: item,
        child: Text(item.formattedName),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<HashAlgorithmType>(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      items: _buildDropdownMenuItems(),
      onChanged: onChanged,
      value: value,
    );
  }
}