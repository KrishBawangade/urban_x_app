import 'package:flutter/material.dart';

class IssueLocationPreview extends StatelessWidget {
  final String? locationText;

  const IssueLocationPreview({
    super.key,
    required this.locationText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Determine UI state based on text
    final bool isLoading = locationText == null;
    final bool isImageNotSelected = locationText == '';

    String displayText;
    if (isImageNotSelected) {
      displayText = 'Select an image to detect location';
    } else if (isLoading) {
      displayText = 'Fetching location...';
    } else {
      displayText = locationText!;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerHighest.withAlpha(40),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayText,
              style: textTheme.bodyMedium?.copyWith(
                color: isLoading
                    ? colorScheme.onSurface.withAlpha(150)
                    : colorScheme.onSurface,
                fontStyle: isLoading ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
