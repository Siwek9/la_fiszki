import 'dart:math';

import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcard_summary.dart';
import 'package:la_fiszki/widgets/flashcard_panel.dart';
import 'package:la_fiszki/widgets/flashcard_side_text.dart';
import 'package:la_fiszki/widgets/flashcard_text_content.dart';
import 'package:la_fiszki/widgets/flashcard_text_input_field.dart';

// ignore: unused_import
import 'dart:developer' as dev;

import 'package:la_fiszki/widgets/prevent_from_losing_progress_dialog.dart';
import 'package:la_fiszki/widgets/writing_answer_button_part.dart';
import 'package:la_fiszki/widgets/writing_answer_buttons.dart';

class FlashcardsWritingPage extends StatefulWidget {
  final int firstSide;
  final List<FlashcardElement> cards;
  final String folderName;
  final Flashcard flashcardData;

  const FlashcardsWritingPage(
      {super.key, required this.cards, required this.folderName, required this.flashcardData, required this.firstSide});

  @override
  State<FlashcardsWritingPage> createState() => _FlashcardsWritingPageState();
}

class _FlashcardsWritingPageState extends State<FlashcardsWritingPage> {
  String? oldAnswer;
  int cardNow = 0;
  FlashcardTextInputStatus statusValue = FlashcardTextInputStatus.normal;
  String? hintText;
  String? prefixText;
  // int? randomTranslate;
  List<FlashcardElement> cardKnown = List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesNotKnown = List<FlashcardElement>.empty(growable: true);
  final TextEditingController _myController = TextEditingController();

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

  _FlashcardsWritingPageState();

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // randomTranslate = randomTranslate ?? Random().nextInt(sideContent("front").length);
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${cardNow + 1}/${widget.cards.length}"),
        ),
        body: LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FlashcardPanel(
                    height: constraints.maxHeight - constraints.maxHeight / 4,
                    topChild: FlashcardSideText(
                        widget.firstSide == 0 ? widget.flashcardData.frontSideName : widget.flashcardData.backSideName),
                    centerChild:
                        FlashcardTextContent(sideContent("front")[Random().nextInt(sideContent("front").length)]),
                    bottomChild: FlashcardTextInputField(
                      prefixText: prefixText,
                      hintText: hintText,
                      controller: _myController,
                      statusValue: statusValue,
                      onSubmit: (value) {
                        if (statusValue == FlashcardTextInputStatus.normal) {
                          if (sideContent("back").contains(((prefixText ?? "") + value))) {
                            setState(() {
                              statusValue = FlashcardTextInputStatus.success;
                            });
                            return true;
                          } else {
                            setState(() {
                              oldAnswer = value;
                              prefixText = null;
                              _myController.text = "";
                              hintText = hintText ?? sideContent("back")[Random().nextInt(sideContent("back").length)];
                              statusValue = FlashcardTextInputStatus.error;
                            });
                            return false;
                          }
                        } else if (statusValue == FlashcardTextInputStatus.error) {
                          if (sideContent("back").contains(value)) {
                            whenUserDoNotKnow(widget.cards[cardNow]);
                            return true;
                          } else {
                            return false;
                          }
                        } else {
                          whenUserKnow(widget.cards[cardNow]);
                          return true;
                        }
                      },
                    ),
                  ),
                  Builder(builder: (context) {
                    if (statusValue == FlashcardTextInputStatus.normal) {
                      return WritingAnswerButtons(buttons: [
                        WritingAnswerButtonPart(
                            text: "Nie wiem",
                            onPressed: () {
                              setState(() {
                                prefixText = null;
                                _myController.text = "";
                                hintText = sideContent("back")[Random().nextInt(sideContent("back").length)];
                                statusValue = FlashcardTextInputStatus.error;
                              });
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                            size: 1),
                        WritingAnswerButtonPart(
                            text: "Podpowiedź",
                            onPressed: () {
                              setState(() {
                                prefixText = prefixText ??
                                    sideContent("back")[Random().nextInt(sideContent("back").length)].characters.first;
                              });
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.85),
                            size: 1),
                        WritingAnswerButtonPart(
                            text: "Sprawdź",
                            onPressed: () {
                              setState(() {
                                if (sideContent("back").contains(((prefixText ?? "") + _myController.text))) {
                                  setState(() {
                                    statusValue = FlashcardTextInputStatus.success;
                                  });
                                } else {
                                  setState(() {
                                    prefixText = null;
                                    oldAnswer = _myController.text;
                                    hintText =
                                        hintText ?? sideContent("back")[Random().nextInt(sideContent("back").length)];
                                    _myController.text = "";
                                    statusValue = FlashcardTextInputStatus.error;
                                  });
                                }
                              });
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                            size: 2),
                      ]);
                    } else if (statusValue == FlashcardTextInputStatus.success) {
                      return WritingAnswerButtons(buttons: [
                        WritingAnswerButtonPart(
                            text: "Kontynuuj",
                            onPressed: () {
                              whenUserKnow(widget.cards[cardNow]);
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                            size: 1),
                      ]);
                    } else {
                      return WritingAnswerButtons(buttons: [
                        WritingAnswerButtonPart(
                            text: "Miałem Racje",
                            onPressed: () {
                              if (oldAnswer != null && oldAnswer != "") {
                                setState(() {
                                  _myController.text = oldAnswer!;
                                  statusValue = FlashcardTextInputStatus.success;
                                });
                              }
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                            size: 1),
                        WritingAnswerButtonPart(
                            text: "Kontynuuj",
                            onPressed: () {
                              if (sideContent("back").contains(((prefixText ?? "") + _myController.text))) {
                                whenUserDoNotKnow(widget.cards[cardNow]);
                              }
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                            size: 2),
                      ]);
                    }
                  }),
                ],
              ),
            );
          },
        ),
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
              mode: "writing",
            ),
          ),
        );
      return;
    }
    setState(() {
      _myController.text = "";
      prefixText = null;
      oldAnswer = null;
      hintText = null;
      statusValue = FlashcardTextInputStatus.normal;
      cardNow++;
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
              mode: "writing",
            ),
          ),
        );
      return;
    }
    setState(() {
      _myController.text = "";
      prefixText = null;
      oldAnswer = null;
      hintText = null;
      statusValue = FlashcardTextInputStatus.normal;
      cardNow++;
    });
  }
}
