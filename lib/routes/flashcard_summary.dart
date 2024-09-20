import 'dart:math';
import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_exclusion_page.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_writing_page.dart';
import 'package:la_fiszki/widgets/condition_display.dart';
import 'package:la_fiszki/widgets/flashcard_panel.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';
import 'package:la_fiszki/widgets/prevent_from_losing_progress_dialog.dart';
import 'package:la_fiszki/widgets/summary_extra_button.dart';
import 'package:la_fiszki/widgets/summary_main_button.dart';

// ignore: unused_import
import 'dart:developer' as dev;


class FlashcardSummary extends StatelessWidget {
  final List<FlashcardElement> knownFlashcards;
  final List<FlashcardElement> doNotKnownFlashcards;
  final String folderName;
  final Flashcard flashcardData;
  final String mode;
  final int firstSide;

  const FlashcardSummary({
    super.key,
    required this.knownFlashcards,
    required this.doNotKnownFlashcards,
    required this.folderName,
    required this.flashcardData,
    required this.mode,
    required this.firstSide,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Gratulacje!",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Column(
                  children: [
                    FlashcardPanel(
                      height: constraints.maxHeight / 2,
                      centerChild: ConditionDisplay(
                        condition: () => doNotKnownFlashcards.isEmpty,
                        ifTrue: Text(
                          "Umiesz już wszystko!\nCzy chcesz rozwiązać te fiszki jeszcze raz?",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        ifFalse: Text(
                          "Umiesz ${knownFlashcards.length} fiszek!\nPozostało ${doNotKnownFlashcards.length} do nauki\nCzy kontynuować naukę?",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    ConditionDisplay(
                      condition: () => doNotKnownFlashcards.isEmpty,
                      ifTrue: SummaryMainButton(
                        width: constraints.maxWidth - 25,
                        height: constraints.maxHeight / 7,
                        onPressed: () => openFlashcardFromStart(context)
                      ),
                      ifFalse: SummaryMainButton(
                        width: constraints.maxWidth - 25, 
                        height: constraints.maxHeight / 7,
                        onPressed: () => openFlashcardAgain(context),
                      )
                    ),
                    ConditionDisplay(
                      condition: () => doNotKnownFlashcards.isEmpty,
                      ifTrue: SummaryExtraButton(
                        height: constraints.maxHeight / 9,
                        width: constraints.maxWidth - 75,
                        onPressed: () {
                          Navigator.pop(context);
                        }
                      ),
                      ifFalse: SummaryExtraButton(
                        height: constraints.maxHeight / 9,
                        width: constraints.maxWidth - 75,
                        onPressed: () {
                          preventFromLosingProgress(context).then(
                            (value) {
                              if (value == true && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        }
                      )
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void openFlashcardAgain(BuildContext context) {
    Random random = Random();
    var shuffleCards = List<FlashcardElement>.from(doNotKnownFlashcards);
    shuffleCards.shuffle(random);
    Navigator.of(context)
      ..pop()
      ..push(
        MaterialPageRoute(
          builder: (context) {
            if (mode == "writing") {
              return FlashcardsWritingPage(
                folderName: folderName,
                cards: shuffleCards,
                flashcardData: flashcardData,
                firstSide: firstSide,
              );
            } else {
              return FlashcardsExclusionPage(
                folderName: folderName,
                cards: shuffleCards,
                flashcardData: flashcardData,
                firstSide: firstSide,
              );
            }
          },
        ),
      );
  }

  void openFlashcardFromStart(BuildContext context) {
    Navigator.of(context)
      ..pop()
      ..push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder(
            future: Flashcard.fromFolderName(folderName),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                Random random = Random();
                var shuffleCards = List<FlashcardElement>.from(snapshot.data!.cards);
                shuffleCards.shuffle(random);
                if (mode == "writing") {
                  return FlashcardsWritingPage(
                    folderName: folderName,
                    cards: shuffleCards,
                    flashcardData: snapshot.data!,
                    firstSide: firstSide,
                  );
                } else {
                  return FlashcardsExclusionPage(
                    folderName: folderName,
                    cards: shuffleCards,
                    flashcardData: snapshot.data!,
                    firstSide: firstSide,
                  );
                }
              } else {
                return LoadingScreen();
              }
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
}
