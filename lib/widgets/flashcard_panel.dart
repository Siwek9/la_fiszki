import 'package:flutter/material.dart';

class FlashcardPanel extends StatelessWidget {
  const FlashcardPanel({super.key, required this.height, this.topChild, this.centerChild, this.bottomChild});

  final double height;
  final Widget? topChild;
  final Widget? centerChild;
  final Widget? bottomChild;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: _getAllElementInsidePanel(),
          ),
        ),
      ),
    );
  }

  List<Widget> _getAllElementInsidePanel() {
    List<Widget> elements = List.empty(growable: true);

    if (topChild != null) {
      elements.add(Positioned.fill(top: 20, child: topChild!));
    }
    if (centerChild != null) {
      elements.add(Center(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(child: centerChild),
          ),
        ),
      ));
    }
    if (bottomChild != null) {
      elements.add(
        Positioned.fill(
          bottom: 20,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: bottomChild!,
          ),
        ),
      );
    }
    return elements;
  }
}
