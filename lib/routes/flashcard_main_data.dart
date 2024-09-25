import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';

class FlashcardMainData extends StatelessWidget {
  const FlashcardMainData({
    super.key,
    required this.content,
  });

  final Flashcard content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndContent(
              title: "Nazwa Fiszek",
              content: content.name,
            ),
            TitleAndContent(
              title: "Autor",
              content: content.author,
            ),
            TitleAndContent(
              title: "Ilość Fiszek",
              content: content.cards.length.toString(),
            ),
            TitleAndContent(
              title: "Pierwsza Strona",
              content: content.frontSideName,
            ),
            TitleAndContent(
              title: "Druga Strona",
              content: content.backSideName,
            ),
          ],
        ),
      ),
    );
  }
}

class TitleAndContent extends StatelessWidget {
  const TitleAndContent({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }
}

class CompareElements extends StatelessWidget {
  const CompareElements(
      {super.key, required this.left, required this.right, this.compare = const Icon(Icons.compare_arrows)});

  // final Flashcard content;

  final Widget left;
  final Widget right;
  final Widget compare;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: left,
          ),
          Expanded(
            child: Align(alignment: Alignment.center, child: compare),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: right),
          )
        ],
      ),
    );
  }
}
