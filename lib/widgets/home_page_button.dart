import 'dart:math';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class HomePageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  const HomePageButton({
    super.key,
    required this.onPressed,
    required this.height,
    this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        fixedSize: WidgetStateProperty.all(
          Size(
            MediaQuery.of(context).size.width,
            height,
          ),
        ),
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        foregroundColor: WidgetStateProperty.all(textColor),
      ),
      onPressed: onPressed,
      child: LayoutBuilder(builder: (context, constrains) {
        return Text(
          text ?? "",
          style: TextStyle(
            fontSize: min(
              35,
              constrains.maxHeight / 3,
            ),
          ),
        );
      }),
    );
  }
}
