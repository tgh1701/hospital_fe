import 'package:flutter/material.dart';

class EditableDataCellWidget extends StatelessWidget {
  final String initialValue;
  final bool editMode;
  final Color fillColor;
  final Function(String) onChanged;
  final TextStyle editStyle;
  final TextStyle displayStyle;

  const EditableDataCellWidget({
    super.key,
    required this.initialValue,
    required this.editMode,
    required this.fillColor,
    required this.onChanged,
    this.editStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.displayStyle = const TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return editMode
        ? TextField(
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        filled: true,
        fillColor: fillColor,
      ),
      style: editStyle,
    )
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        initialValue,
        style: displayStyle,
      ),
    );
  }
}

