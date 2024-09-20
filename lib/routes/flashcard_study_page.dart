import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/flashcard_summary.dart';
import 'package:la_fiszki/widgets/prevent_from_losing_progress_dialog.dart';

class FlashcardStudyPage extends StatefulWidget {
  const FlashcardStudyPage(
      {super.key, required this.cards, required this.folderName, required this.flashcardData, required this.firstSide});

  final int firstSide;
  final List<FlashcardElement> cards;
  final String folderName;
  final Flashcard flashcardData;

  @override
  State<StatefulWidget> createState() => FlashcardStudyPageState();
}

class FlashcardStudyPageState<T extends FlashcardStudyPage> extends State<T> {
  int cardNow = 0;
  bool sideNow = true;
  List<FlashcardElement> cardKnown = List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesNotKnown = List<FlashcardElement>.empty(growable: true);

  // late BoxConstraints constraints;
  String get mode {
    return "none";
  }

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("${cardNow + 1}/${widget.cards.length}"),
          ),
          body: child),
    );
  }

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
              mode: mode,
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
              mode: mode,
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
