import 'package:flutter/material.dart';

class IssueSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const IssueSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.send_rounded),
        label: const Text("Submit Issue"),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: colorScheme.onPrimary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
