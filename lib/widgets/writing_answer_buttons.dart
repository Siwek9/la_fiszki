import 'package:flutter/material.dart';

class WritingAnswerButtons extends StatelessWidget {
  const WritingAnswerButtons({super.key, required this.buttons});

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        child: PhysicalModel(
          elevation: 16.0,
          color: Colors.transparent,
          shadowColor: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          child: Flex(
            direction: Axis.horizontal,
            children: buttons
          ),
        ),
      ),
    );
  }
}