import 'package:flutter/material.dart';
import 'package:urban_x_app/features/home/presentation/widgets/issue_card.dart';

class MyIssuesList extends StatelessWidget {
  final String selectedFilter;

  const MyIssuesList({
    super.key,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final myIssues = [
      {
        'title': 'Garbage not collected near Somalwada',
        'description':
            'Garbage bins near Trimurti Nagar Square are overflowing and not collected for 3 days.',
        'imageUrl': 'assets/images/mock/garbage.png',
        'location':
            'Trimurti Nagar Square, Wardha Road, Nagpur, Maharashtra 440025',
        'status': 'Pending',
        'upvotes': 10,
        'timeAgo': '4h ago',
        'postedBy': 'You',
      },
      {
        'title': 'Broken streetlight opposite Balaji Apartment',
        'description':
            'Streetlight is flickering continuously, creating visibility issues at night.',
        'imageUrl': 'assets/images/mock/broken_streetlight2.png',
        'location':
            'Balaji Apartment, Somalwada, Wardha Road, Nagpur, Maharashtra 440025',
        'status': 'In Progress',
        'upvotes': 6,
        'timeAgo': '1d ago',
        'postedBy': 'You',
      },
      {
        'title': 'Pothole near Hotel Airport Centre Point',
        'description':
            'Deep pothole near the hotel entrance causing traffic bottlenecks during evenings.',
        'imageUrl': 'assets/images/mock/pothole3.png',
        'location':
            'Near Hotel Airport Centre Point, Wardha Road, Nagpur, Maharashtra 440025',
        'status': 'Resolved',
        'upvotes': 21,
        'timeAgo': '3d ago',
        'postedBy': 'You',
      },
    ];

    final filteredIssues = selectedFilter == 'All'
        ? myIssues
        : myIssues.where((i) => i['status'] == selectedFilter).toList();

    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInCubic,
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: filteredIssues.isEmpty
            ? Padding(
                key: ValueKey('empty-$selectedFilter'),
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: 64, color: colorScheme.outlineVariant),
                    const SizedBox(height: 12),
                    Text(
                      'No ${selectedFilter.toLowerCase()} issues found',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.outline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                key: ValueKey('list-$selectedFilter'),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: List.generate(filteredIssues.length, (index) {
                    final issue = filteredIssues[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: IssueCard(issue: issue),
                    );
                  }),
                ),
              ),
      ),
    );
  }
}
