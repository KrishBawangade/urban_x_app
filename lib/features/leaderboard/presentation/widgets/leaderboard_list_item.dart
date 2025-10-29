import 'package:flutter/material.dart';

class LeaderboardListItem extends StatelessWidget {
  final String name;
  final int points;
  final int rank;

  const LeaderboardListItem({
    super.key,
    required this.name,
    required this.points,
    required this.rank,
  });

  /// Helper to get initials from the user's name
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _getInitials(name);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withAlpha(100)),
      ),
      child: Row(
        children: [
          // Rank number in front
          Text(
            '#$rank',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: rank == 1
                  ? Colors.amber
                  : rank == 2
                      ? Colors.grey
                      : rank == 3
                          ? Colors.brown
                          : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),

          // Avatar with initials or person icon
          CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.primary.withAlpha(40),
            child: initials.isNotEmpty
                ? Text(
                    initials,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: theme.colorScheme.primary.withAlpha(160),
                  ),
          ),
          const SizedBox(width: 12),

          // Name and points
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            "$points pts",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
