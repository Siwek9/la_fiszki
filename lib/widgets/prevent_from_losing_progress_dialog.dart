import 'package:flutter/material.dart';

class PreventFromLosingProgressDialog extends StatelessWidget {
  const PreventFromLosingProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Text('Wyjście'),
      content: Text('Twoje postępy w tej sesji fiszek nie zostaną zapisane. Czy na pewno chcesz wyjść?'),
      actions: [
        TextButton(
          child: Text('Anuluj'),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text('Potwierdź'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}