class FlashcardElement {
  List<String> frontSide;
  List<String> backSide;

  FlashcardElement({required this.frontSide, required this.backSide});

  static bool isFlashcardElement(dynamic element) {
    return element?['front'] != null && element?['back'] != null;
  }
}
