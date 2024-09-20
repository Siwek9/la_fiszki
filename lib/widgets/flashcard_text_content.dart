import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FlashcardTextContent extends StatelessWidget {
  const FlashcardTextContent(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: Theme.of(context).textTheme.displayMedium!.fontSize!),
      textAlign: TextAlign.center,
    );
  }
}