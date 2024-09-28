import 'package:flutter/material.dart';

class StartStudyingButton extends StatelessWidget {
  const StartStudyingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  final Widget label;
  final Widget? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      decoration: BoxDecoration(
          // border: ,
          ),
      child: ElevatedButton.icon(
        label: label,
        icon: icon,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
          foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconSize: WidgetStatePropertyAll(40),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 35.0,
            ),
          ),
        ),
        iconAlignment: IconAlignment.start,
        onPressed: onPressed,
        // child: children,
      ),
    );
  }
}
