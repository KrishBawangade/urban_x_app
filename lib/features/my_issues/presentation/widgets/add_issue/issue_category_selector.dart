import 'package:flutter/material.dart';

class IssueCategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const IssueCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🌆 Expanded and relevant list of civic issue categories
    final categories = [
      "Road Damage",
      "Garbage",
      "Street Light",
      "Water Leakage",
      "Sewage Overflow",
      "Illegal Parking",
      "Noise Pollution",
      "Air Pollution",
      "Tree Cutting",
      "Encroachment",
      "Public Safety",
      "Drainage",
      "Animal Issue",
      "Electric Pole",
      "Other",
    ];

    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Category",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha(25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: selectedCategory != null
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: selectedCategory != null ? 1.8 : 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: selectedCategory != null
                  ? colorScheme.primaryContainer.withAlpha(60)
                  : colorScheme.surfaceContainerHighest.withAlpha(40),
            ),
            hint: const Text("Choose an issue category"),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            dropdownColor: colorScheme.surface,
            items: categories.map((category) {
              final isSelected = category == selectedCategory;
              return DropdownMenuItem<String>(
                value: category,
                child: Row(
                  children: [
                    if (isSelected) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      category,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onCategoryChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
