import 'package:flut_crack/core/algorithm_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class HashAlgorithmSelector extends HookWidget {

  final String label;
  final void Function(AlgorithmType?)? onChanged;
  final AlgorithmType? value;

  const HashAlgorithmSelector({
    super.key,
    required this.label,
    this.value,
    this.onChanged
  });

  List<DropdownMenuItem<AlgorithmType>> _buildDropdownMenuItems(){
    return AlgorithmType.values.map((AlgorithmType item) {
      return DropdownMenuItem<AlgorithmType>(
        value: item,
        child: Text(item.formattedName),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AlgorithmType>(
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