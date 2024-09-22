import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  final void Function(int sideIndex) onSelected;
  final List<String> buttons;
  final String title;

  const SwitchButton({
    super.key,
    required this.onSelected,
    required this.buttons,
    required this.title,
  });

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  var selectedSide = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Flex(
              direction: Axis.horizontal,
              children: widget.buttons.indexed.map((values) {
                return Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSelected(values.$1);
                      setState(() {
                        selectedSide = values.$1;
                      });
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 3.0,
                        ),
                      )),
                      shadowColor: WidgetStatePropertyAll(Colors.transparent),
                      backgroundColor: WidgetStateProperty.all(
                        selectedSide == values.$1
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    child: Text(
                      values.$2,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: selectedSide == values.$1
                            ? Theme.of(context).colorScheme.onTertiary
                            : Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }
}
