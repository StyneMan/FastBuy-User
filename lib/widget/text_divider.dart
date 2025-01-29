import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final Widget text;

  const TextDivider({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
            endIndent: 8, // Add spacing between line and text
          ),
        ),
        text,
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 8, // Add spacing between text and line
          ),
        ),
      ],
    );
  }
}
