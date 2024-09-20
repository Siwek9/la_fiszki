import 'dart:math';

import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcard_summary.dart';
import 'package:la_fiszki/widgets/choose_button.dart';

// ignore: unused_import
import 'dart:developer' as dev;

import 'package:la_fiszki/widgets/flashcard_panel.dart';
import 'package:la_fiszki/widgets/flashcard_side_text.dart';
import 'package:la_fiszki/widgets/flashcard_text_content.dart';
import 'package:la_fiszki/widgets/prevent_from_losing_progress_dialog.dart';

class FlashcardsExclusionPage extends StatefulWidget {
  final int firstSide;
  final List<FlashcardElement> cards;
  final String folderName;
  final Flashcard flashcardData;

  const FlashcardsExclusionPage(
      {super.key, required this.cards, required this.folderName, required this.flashcardData, required this.firstSide});

  @override
  State<FlashcardsExclusionPage> createState() => _FlashcardsExclusionPageState();
}

class _FlashcardsExclusionPageState extends State<FlashcardsExclusionPage> {
  _FlashcardsExclusionPageState();
  int cardNow = 0;
  bool sideNow = true;
  // int? randomTranslate;
  List<FlashcardElement> cardKnown = List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesNotKnown = List<FlashcardElement>.empty(growable: true);

  List<String> sideContent(String side) {
    if (side == "front") {
      if (widget.firstSide == 0) {
        return widget.cards[cardNow].frontSide;
      } else {
        return widget.cards[cardNow].backSide;
      }
    } else {
      if (widget.firstSide == 0) {
        return widget.cards[cardNow].backSide;
      } else {
        return widget.cards[cardNow].frontSide;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${cardNow + 1}/${widget.cards.length}"),
        ),
        body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Column(children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    sideNow = !sideNow;
                  });
                },
                child: FlashcardPanel(
                    height: constraints.maxHeight / 2,
                    topChild: FlashcardSideText((sideNow ^ (widget.firstSide == 1))
                        ? widget.flashcardData.frontSideName
                        : widget.flashcardData.backSideName),
                    centerChild: FlashcardTextContent(sideNow
                        ? sideContent("front")[Random().nextInt(sideContent("front").length)]
                        : sideContent("back").join('/\n')))),
            Flex(
              direction: Axis.horizontal,
              children: [
                ChooseButton(
                  text: "Wiem",
                  color: WidgetStatePropertyAll(Colors.green),
                  constraints: constraints,
                  onPressed: () {
                    whenUserKnow(widget.cards[cardNow]);
                  },
                ),
                ChooseButton(
                  text: "Nie wiem",
                  color: WidgetStatePropertyAll(Colors.red),
                  constraints: constraints,
                  onPressed: () {
                    whenUserDoNotKnow(widget.cards[cardNow]);
                  },
                ),
              ],
            )
          ]);
        }),
      ),
    );
  }

  Future<bool> preventFromLosingProgress(BuildContext context) async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return PreventFromLosingProgressDialog();
      },
    );
    return shouldPop ?? false;
  }

  void whenUserKnow(FlashcardElement card) {
    cardKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              knownFlashcards: cardKnown,
              doNotKnownFlashcards: cardDoesNotKnown,
              flashcardData: widget.flashcardData,
              firstSide: widget.firstSide,
              mode: "exclusion",
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
      sideNow = true;
    });
  }

  void whenUserDoNotKnow(FlashcardElement card) {
    cardDoesNotKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              knownFlashcards: cardKnown,
              doNotKnownFlashcards: cardDoesNotKnown,
              flashcardData: widget.flashcardData,
              firstSide: widget.firstSide,
              mode: "exclusion",
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
      sideNow = true;
    });
  }
}
