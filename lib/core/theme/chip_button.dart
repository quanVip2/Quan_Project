import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final String label;
  final void Function()? onChipClicked;
  final bool isSelected;

  const ChipButton({
    super.key, 
    required this.label, 
    this.onChipClicked,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: onChipClicked,
        child: Chip(
          backgroundColor: isSelected ? Colors.white : Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
          ),
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
