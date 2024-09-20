import 'package:flutter/material.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class ConditionDisplay extends StatelessWidget {
  final bool Function() condition;
  final Widget ifTrue;
  final Widget ifFalse;
  
  const ConditionDisplay({
    super.key,
    required this.condition,
    required this.ifTrue,
    required this.ifFalse
  });

  @override
  Widget build(BuildContext context) {
    if (condition()) {
      return ifTrue;
    }
    else {
      return ifFalse;
    }
  }

}
