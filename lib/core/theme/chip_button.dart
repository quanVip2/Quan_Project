import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final String label;
  final void Function()? onChipClicked;

  const ChipButton({super.key, required this.label, this.onChipClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: GestureDetector(
        onTap: onChipClicked,
        child: Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
          ),
          label: Text(label),
        ),
      ),
    );
  }
}
