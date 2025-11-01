import 'package:flutter/material.dart';

class IssueSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const IssueSubmitButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                ),
              )
            : const Icon(Icons.send_rounded),
        label: Text(isLoading ? "Submitting..." : "Submit Issue"),
        style: FilledButton.styleFrom(
          backgroundColor: isLoading
              ? colorScheme.primary.withAlpha(180)
              : colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: colorScheme.onPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
