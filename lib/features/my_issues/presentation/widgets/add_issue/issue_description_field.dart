import 'package:flutter/material.dart';

class IssueDescriptionField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const IssueDescriptionField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        labelText: "Describe the issue",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (val) =>
          (val == null || val.isEmpty) ? "Please enter a description" : null,
      onChanged: onChanged,
    );
  }
}
