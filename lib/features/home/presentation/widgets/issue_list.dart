import 'package:flutter/material.dart';
import 'issue_card.dart';

class IssueList extends StatelessWidget {
  const IssueList({super.key});

  @override
  Widget build(BuildContext context) {

    // 🧱 Raw dummy issues within 2km radius
    final rawIssues = [
      {
        'title': 'Pothole near Somalwada Signal',
        'description':
            'A large pothole has formed close to the Somalwada traffic signal, slowing traffic during peak hours.',
        'imageUrl': 'assets/images/mock/pothole2.png',
        'location':
            'Somalwada Traffic Signal, Wardha Road, Nagpur, Maharashtra 440025',
        'distanceKm': 0.5,
        'status': 'Pending',
        'upvotes': 42,
        'timeAgo': '2h ago',
        'postedBy': 'Ravi Patil',
      },
      {
        'title': 'Broken Streetlight Opposite Bus Stop',
        'description':
            'Streetlight opposite the Somalwada bus stop on Wardha Road has been non-functional for several nights.',
        'imageUrl': 'assets/images/mock/broken_streetlight.png',
        'location':
            'Opp. Somalwada Bus Stop, Wardha Road, Nagpur, Maharashtra 440025',
        'distanceKm': 1.2,
        'status': 'In Progress',
        'upvotes': 18,
        'timeAgo': '6h ago',
        'postedBy': 'Neha Kulkarni',
      },
      {
        'title': 'Overflowing Drain Causing Smell',
        'description':
            'Drain near Trimurti Nagar Square off Wardha Road is clogged and overflowing, causing an unpleasant smell.',
        'imageUrl': 'assets/images/mock/drainage_overflow.png',
        'location':
            'Trimurti Nagar Square, Wardha Road, Nagpur, Maharashtra 440025',
        'distanceKm': 0.9,
        'status': 'Pending',
        'upvotes': 34,
        'timeAgo': '8h ago',
        'postedBy': 'Amit Verma',
      },
      {
        'title': 'Construction Debris Blocking Footpath',
        'description':
            'Construction debris dumped beside Hotel Airport Centre Point is blocking pedestrian movement.',
        'imageUrl': 'assets/images/mock/footpath_blockage.png',
        'location':
            'Near Hotel Airport Centre Point, Wardha Road, Nagpur, Maharashtra 440025',
        'distanceKm': 1.8,
        'status': 'In Progress',
        'upvotes': 12,
        'timeAgo': '1d ago',
        'postedBy': 'Sneha Joshi',
      },
      {
        'title': 'Water Leak Creating Muddy Patch',
        'description':
            'Small underground pipe leakage near Ajni Railway Colony gate causing muddy road surface.',
        'imageUrl': 'assets/images/mock/water_leak.png',
        'location':
            'Ajni Railway Colony Gate, Wardha Road, Nagpur, Maharashtra 440025',
        'distanceKm': 1.95,
        'status': 'Pending',
        'upvotes': 7,
        'timeAgo': 'Just now',
        'postedBy': 'Arjun Deshmukh',
      },

      // 🚫 Example of an issue outside 2km (will be filtered out)
      {
        'title': 'Street Sign Fallen at Distant Locality',
        'description': 'This issue is outside the 2km radius and should not appear.',
        'imageUrl': 'https://picsum.photos/400/200?random=16',
        'location': 'Mankapur, Nagpur, Maharashtra 440030',
        'distanceKm': 3.4,
        'status': 'Pending',
        'upvotes': 3,
        'timeAgo': '2d ago',
        'postedBy': 'Local User',
      },
    ];

    // 🧮 Filter only issues within 2 km radius
    final nearbyIssues =
        rawIssues.where((i) => (i['distanceKm'] as num? ?? 999) <= 2.0).toList();

    return SliverList.separated(
      itemCount: nearbyIssues.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final issue = nearbyIssues[index];
        return IssueCard(issue: issue);
      },
    );
  }
}
