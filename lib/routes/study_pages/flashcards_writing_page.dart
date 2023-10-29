// TODO pls clean this mess pls pls
import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcard_summary.dart';
import 'package:la_fiszki/widgets/buttons_when_error.dart';

// ignore: unused_import
import 'dart:developer' as dev;

import 'package:la_fiszki/widgets/buttons_when_normal.dart';
import 'package:la_fiszki/widgets/buttons_when_success.dart';

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
  List<FlashcardElement> cardKnown = List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesntKnown = List<FlashcardElement>.empty(growable: true);
  final TextEditingController _myController = TextEditingController();

  String sideContent(String side) {
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
                  SizedBox(
                    height: constraints.maxHeight - constraints.maxHeight / 4,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  widget.firstSide == 0
                                      ? widget.flashcardData.frontSideName
                                      : widget.flashcardData.backSideName,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  sideContent("front"),
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: FlashcardTextInputField(
                                    prefixText: prefixText,
                                    hintText: hintText,
                                    controller: _myController,
                                    statusValue: statusValue,
                                    onSubmit: (value) {
                                      if (statusValue == FlashcardTextInputStatus.normal) {
                                        if (((prefixText ?? "") + value) == sideContent("back")) {
                                          setState(() {
                                            statusValue = FlashcardTextInputStatus.success;
                                          });
                                          return true;
                                        } else {
                                          setState(() {
                                            oldAnswer = value;
                                            prefixText = null;
                                            _myController.text = "";
                                            hintText = sideContent("back");
                                            statusValue = FlashcardTextInputStatus.error;
                                          });
                                          return false;
                                        }
                                      } else {
                                        if (value == sideContent("back")) {
                                          whenUserDontKnow(widget.cards[cardNow]);
                                          return true;
                                        } else {
                                          return false;
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    if (statusValue == FlashcardTextInputStatus.normal) {
                      return ButtonsWhenNormal(
                        whenHint: () {
                          setState(() {
                            prefixText = sideContent("back").characters.first;
                          });
                        },
                        whenDontKnow: () {
                          setState(() {
                            prefixText = null;
                            hintText = sideContent("back");
                            statusValue = FlashcardTextInputStatus.error;
                          });
                        },
                        whenSubmit: () {
                          if (((prefixText ?? "") + _myController.text) == sideContent("back")) {
                            setState(() {
                              statusValue = FlashcardTextInputStatus.success;
                            });
                          } else {
                            setState(() {
                              prefixText = null;
                              oldAnswer = _myController.text;
                              hintText = sideContent("back");
                              _myController.text = "";
                              statusValue = FlashcardTextInputStatus.error;
                            });
                          }
                        },
                      );
                    } else if (statusValue == FlashcardTextInputStatus.success) {
                      return ButtonsWhenSuccess(
                        whenContinue: () {
                          whenUserKnow(widget.cards[cardNow]);
                        },
                      );
                    } else {
                      return ButtonsWhenError(
                        whenRewritten: () {
                          if (((prefixText ?? "") + _myController.text) == sideContent("back")) {
                            whenUserDontKnow(widget.cards[cardNow]);
                          }
                        },
                        whenWasRight: () {
                          if (oldAnswer != "") {
                            setState(() {
                              _myController.text = oldAnswer!;
                              statusValue = FlashcardTextInputStatus.success;
                            });
                          }
                        },
                      );
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
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text('Wyjście'),
          content: Text('Twoje postępy w tej sesji fiszek nie zostaną zapisane. Czy na pewno chcesz wyjść?'),
          actions: [
            TextButton(
              child: Text('Anuluj'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Potwierdź'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
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
              dontKnownFlashcards: cardDoesntKnown,
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

  void whenUserDontKnow(FlashcardElement card) {
    cardDoesntKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              knownFlashcards: cardKnown,
              dontKnownFlashcards: cardDoesntKnown,
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

enum FlashcardTextInputStatus { normal, success, error }

class FlashcardTextInputField extends StatefulWidget {
  final bool Function(String) onSubmit;

  final FlashcardTextInputStatus statusValue;

  final TextEditingController controller;

  final String? hintText;

  final String? prefixText;

  const FlashcardTextInputField({
    super.key,
    required this.onSubmit,
    required this.statusValue,
    required this.controller,
    this.hintText,
    this.prefixText,
  });

  @override
  State<FlashcardTextInputField> createState() => _FlashcardTextInputFieldState();
}

class _FlashcardTextInputFieldState extends State<FlashcardTextInputField> {
  late FocusNode _myFocusNode;
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);
  // final TextEditingController _myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _myFocusNode.removeListener(_onFocusChange);
    _myFocusNode.dispose();
    _myFocusNotifier.dispose();
    // widget.controller.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
  }

  Color setFilledColor(isFocus) {
    if (widget.statusValue == FlashcardTextInputStatus.normal) {
      return isFocus ? Colors.white.withOpacity(0.2) : Colors.transparent;
    } else if (widget.statusValue == FlashcardTextInputStatus.success) {
      return Colors.green.withOpacity(1);
    } else {
      return Colors.red.withOpacity(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _myFocusNotifier,
      builder: (context, isFocus, child) {
        return TextField(
          // autocorrect: false,
          controller: widget.controller,
          onSubmitted: (value) => setState(() {
            widget.onSubmit(value);
          }),
          focusNode: _myFocusNode,
          autofocus: true,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress, // for turning off autocorrect
          maxLines: 1,
          clipBehavior: Clip.hardEdge,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
          cursorColor: Colors.white,
          cursorOpacityAnimates: true,
          decoration: InputDecoration(
            hintText: widget.hintText ?? "Wpisz tekst",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            prefixText: widget.prefixText,
            prefixIcon: () {
              if (widget.statusValue == FlashcardTextInputStatus.error) {
                return Icon(Icons.close, color: Colors.white);
              } else if (widget.statusValue == FlashcardTextInputStatus.success) {
                return Icon(Icons.done, color: Colors.white);
              } else {
                return null;
              }
            }(),
            suffixIcon: GestureDetector(
              onTap: () => setState(() {
                widget.onSubmit(widget.controller.text);
              }),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            filled: true,
            fillColor: setFilledColor(isFocus),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.5),
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
        );
      },
    );
  }
}
