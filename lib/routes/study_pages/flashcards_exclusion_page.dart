import 'dart:math';

import 'package:flutter/material.dart';
import 'package:la_fiszki/routes/flashcard_study_page.dart';
import 'package:la_fiszki/widgets/choose_button.dart';
import 'package:la_fiszki/widgets/flashcard_panel.dart';
import 'package:la_fiszki/widgets/flashcard_side_text.dart';
import 'package:la_fiszki/widgets/flashcard_text_content.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardsExclusionPage extends FlashcardStudyPage {
  const FlashcardsExclusionPage(
      {super.key,
      required super.cards,
      required super.folderName,
      required super.flashcardData,
      required super.firstSide});

  @override
  State createState() => _FlashcardsExclusionPageState();
}

class _FlashcardsExclusionPageState extends FlashcardStudyPageState<FlashcardsExclusionPage> {
  _FlashcardsExclusionPageState();

  @override
  String get mode {
    return "exclusion";
  }

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return super.build(
      context,
      child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return Column(
          children: [
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
          ],
        );
      }),
    );
  }
}
