import 'package:flutter/material.dart';

class ChooseAnswerButton extends StatelessWidget {
  const ChooseAnswerButton({
    super.key,
    required this.text,
    required this.color,
    required this.constraints,
    required this.onPressed,
    required this.topText,
  });
  final String text;
  final WidgetStateProperty<Color> color;
  final BoxConstraints constraints;
  final VoidCallback onPressed;

  final String topText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            height: constraints.maxHeight / 2,
            width: constraints.maxWidth / 2,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: color,
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              ),
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          Positioned.fill(
            top: 15.0,
            child: IgnorePointer(
              child: Text(
                topText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
