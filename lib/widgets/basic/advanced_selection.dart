import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class AdvancedSelection extends StatelessWidget {
  final bool isSelected;
  final Function updateSelection;
  final String nameSelected;
  final String nameDeselected;

  AdvancedSelection(
      {this.isSelected,
      this.updateSelection,
      this.nameDeselected,
      this.nameSelected});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: updateSelection,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isSelected ? nameSelected : nameDeselected),
          Icon(
              isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
