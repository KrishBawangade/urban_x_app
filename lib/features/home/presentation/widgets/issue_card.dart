import 'package:flutter/material.dart';
import 'package:urban_x_app/core/constants/app_colors.dart';

class IssueCard extends StatelessWidget {
  final Map<String, dynamic> issue;
  const IssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final status = (issue['status'] ?? 'Pending').toString();
    final statusColor = _getStatusColor(status);
    final statusBg = statusColor.withAlpha(25);
    final distance = issue['distanceKm'] != null
        ? '${issue['distanceKm'].toString()} km away'
        : '(Within 2 km)';

    final imagePath = issue['imageUrl']; // Local file path

    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withAlpha(25),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Local Image with Fallback
          if (imagePath != null)
            Image.asset(
              imagePath,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildPlaceholderIcon(colorScheme),
            )
          else
            _buildPlaceholderIcon(colorScheme),

          // 📋 Content Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧾 Title
                Text(
                  issue['title'] ?? 'Untitled Issue',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),

                // 📝 Description
                Text(
                  issue['description'] ?? 'No description available.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // 📍 Location + Distance
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue['location'] ??
                                'Wardha Road, Somalwada, Nagpur, Maharashtra 440025',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            distance,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 👤 User + Time
                Row(
                  children: [
                    Icon(Icons.person_rounded,
                        size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        issue['postedBy'] ?? 'Posted by Citizen',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      issue['timeAgo'] ?? 'Just now',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: AppColors.divider.withAlpha(60), height: 16),

                // ❤️ Upvote + Status
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        // TODO: handle upvote logic
                      },
                      child: Row(
                        children: [
                          Icon(Icons.thumb_up_alt_rounded,
                              size: 20, color: colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${issue['upvotes'] ?? 0} Upvotes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 Status color logic
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.orange;
    }
  }

  // 🖼 Placeholder
  Widget _buildPlaceholderIcon(ColorScheme colorScheme) {
    return Container(
      height: 190,
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest.withAlpha(60),
      child: Center(
        child: Icon(
          Icons.image_rounded,
          size: 60,
          color: colorScheme.onSurfaceVariant.withAlpha(140),
        ),
      ),
    );
  }
}
