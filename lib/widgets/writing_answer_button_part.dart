import 'package:flutter/material.dart';

class WritingAnswerButtonPart extends StatelessWidget {
  const WritingAnswerButtonPart(
      {super.key, required this.text, required this.onPressed, required this.backgroundColor, this.size = 1});

  final int size;
  final Color backgroundColor;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: size,
      child: FilledButton(
        style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll(Size.fromHeight(60)),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        onPressed: onPressed,
        child: OverflowBox(
          alignment: Alignment.center,
          maxWidth: double.infinity,
          child: Text(text),
        ),
      ),
    );
  }
}
