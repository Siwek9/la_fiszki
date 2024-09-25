import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/routes/list_of_sets_page.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcards_storage.dart';
import 'package:la_fiszki/widgets/home_page_button.dart';
import 'package:la_fiszki/widgets/custom_snack_bars.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: constraints.maxHeight / 2 - 50,
                    alignment: Alignment.center,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Image.asset(
                        "assets/images/logo.png",
                        width: constraints.maxWidth - 25,
                        height: constraints.maxHeight - 25,
                        fit: BoxFit.cover,
                      );
                    }),
                  ),
                  HomePageButton(
                    onPressed: () async {
                      final url = Uri.parse('http://la-fiszki.com');
                      if (await canLaunchUrl(url)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    text: "Stwórz fiszkę (Strona Internetowa)",
                    height: 50,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  HomePageButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOfSetsPage(),
                        ),
                      );
                    },
                    text: "Otwórz fiszke",
                    height: constraints.maxHeight / 3,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  HomePageButton(
                    onPressed: () => importFlashcardFromFile(
                      whenError: (String errorMessage) =>
                          CustomSnackBars.onError(text: "Wystąpił błąd podczas importowania fiszki ($errorMessage)")
                              .show(context),
                      whenSuccess: (String flashcardName) =>
                          CustomSnackBars.onSuccess(text: "Fiszka '$flashcardName' została dodana poprawnie")
                              .show(context),
                    ),
                    text: "Importuj fiszke",
                    height: constraints.maxHeight / 6,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    textColor: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void importFlashcardFromFile(
      {required void Function(String) whenError, required void Function(String) whenSuccess}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null) return;

    File filePicked = File(result.files.single.path ?? "");
    if (!await filePicked.exists()) {
      whenError("Plik nie istnieje");
      return;
    }

    String fileContent = await filePicked.readAsString();
    if (!Flashcard.isFlashcard(fileContent)) {
      whenError("Plik nie jest fiszką");
      return;
    }
    var flashcardFolderName = await FlashcardsStorage.addNewFlashcard(fileContent);

    var catalogueObject = Catalogue.createCatalogueElement(
      folderName: flashcardFolderName,
      json: jsonDecode(fileContent),
    );
    await Catalogue.addElement(catalogueObject);

    var flashcardName = jsonDecode(fileContent)['name'];
    whenSuccess(flashcardName);
  }
}
