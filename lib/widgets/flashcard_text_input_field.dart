
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

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
  int fieldLines = 2;
  int numLines = 0;

  @override
  void initState() {
    super.initState();

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);

    _scrollControllerGroup = LinkedScrollControllerGroup();
    _textFieldScrollController = _scrollControllerGroup.addAndGet();
    _textHintScrollController = _scrollControllerGroup.addAndGet();
  }

  @override
  void dispose() {
    _myFocusNode.removeListener(_onFocusChange);
    _myFocusNode.dispose();
    _myFocusNotifier.dispose();

    _textFieldScrollController.dispose();
    _textHintScrollController.dispose();

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

  late LinkedScrollControllerGroup _scrollControllerGroup;
  late ScrollController _textFieldScrollController;
  late ScrollController _textHintScrollController;


  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.titleLarge!;

    return ValueListenableBuilder(
      valueListenable: _myFocusNotifier,
      builder: (context, isFocus, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              TextField(
                scrollController: _textFieldScrollController,
                textAlignVertical: TextAlignVertical.top,
                controller: widget.controller,
                onSubmitted: (value) => setState(() {
                  widget.onSubmit(value);
                }),
                focusNode: _myFocusNode,
                autofocus: true,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress, // for turning off auto-correct
                clipBehavior: Clip.hardEdge,
                style: textStyle.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                cursorColor: Colors.white,
                cursorOpacityAnimates: true,
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: widget.hintText == null ? "Wpisz tekst" : null,
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
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 15.0,
                      left: 48.0,
                      right: 48.0,
                    ),
                    child: Text(
                      widget.hintText ?? "",
                      overflow: TextOverflow.fade,
                      // softWrap: false,
                      style: textStyle.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
