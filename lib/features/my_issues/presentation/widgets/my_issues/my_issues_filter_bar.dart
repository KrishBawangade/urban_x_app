import 'package:flutter/material.dart';

class MyIssuesFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const MyIssuesFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filters = ['All', 'Pending', 'In Progress', 'Resolved'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(155),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(100),
        ),
      ),

      // 🔹 Smooth horizontal scroll for filters
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter;
            final activeColor = _getFilterColor(filter);
            final icon = _getFilterIcon(filter);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onFilterChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected
                        ? activeColor.withAlpha(5)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? activeColor.withAlpha(100)
                          : colorScheme.outlineVariant.withAlpha(30),
                      width: isSelected ? 1.4 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: activeColor.withAlpha(30),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        color: isSelected
                            ? activeColor
                            : colorScheme.onSurfaceVariant.withAlpha(150),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        filter,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? activeColor
                              : colorScheme.onSurfaceVariant.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Pending':
        return Icons.timelapse_rounded;
      case 'In Progress':
        return Icons.engineering_rounded;
      case 'Resolved':
        return Icons.verified_rounded;
      default:
        return Icons.apps_rounded;
    }
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.lightBlueAccent;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.deepPurpleAccent;
    }
  }
}
