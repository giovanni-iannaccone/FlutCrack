import 'package:flut_crack/data/algorithm_type.dart';
import 'package:flutter/material.dart';

List<DropdownMenuItem<AlgorithmType>> buildDropdownMenuItems(){
    return AlgorithmType.values.map((AlgorithmType item) {
      return DropdownMenuItem<AlgorithmType>(
        value: item,
        child: Text(item.formattedName),
      );
    }).toList();
  }