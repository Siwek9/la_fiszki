import 'package:flutter/material.dart';

class SummaryExtraButton extends StatelessWidget {
  const SummaryExtraButton({super.key, required this.width, required this.height, required this.onPressed});

  final double width;
  final double height;
  final void Function() onPressed;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Wróć do menu głównego",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ),
    );
  }
}