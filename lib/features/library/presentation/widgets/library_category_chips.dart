import 'package:flutter/material.dart';
import '../../../../core/theme/chip_button.dart';

class LibraryCategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const LibraryCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          ChipButton(
            label: "Playlists",
            onChipClicked: () => onCategorySelected("Playlists"),
            isSelected: selectedCategory == "Playlists",
          ),
          ChipButton(
            label: "Podcasts",
            onChipClicked: () => onCategorySelected("Podcasts"),
            isSelected: selectedCategory == "Podcasts",
          ),
          ChipButton(
            label: "Albums",
            onChipClicked: () => onCategorySelected("Albums"),
            isSelected: selectedCategory == "Albums",
          ),
          ChipButton(
            label: "Artists",
            onChipClicked: () => onCategorySelected("Artists"),
            isSelected: selectedCategory == "Artists",
          ),
        ],
      ),
    );
  }
} 