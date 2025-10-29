import 'package:flutter/material.dart';
import 'top_user_card.dart';

class TopUsersSection extends StatelessWidget {
  const TopUsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final topUsers = [
      {'name': 'Aarav Sharma', 'points': 980, 'rank': 1},
      {'name': 'Isha Verma', 'points': 860, 'rank': 2},
      {'name': 'Rohan Mehta', 'points': 820, 'rank': 3},
    ];

    return SizedBox(
      height: 270,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Positioning podiums
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodiumUser(
                  context,
                  topUsers[1],
                  offsetY: 40,
                ), // 2nd place
                _buildPodiumUser(context, topUsers[0], offsetY: 0), // 1st place
                _buildPodiumUser(
                  context,
                  topUsers[2],
                  offsetY: 50,
                ), // 3rd place
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumUser(
    BuildContext context,
    Map<String, dynamic> user, {
    required double offsetY,
  }) {
    final theme = Theme.of(context);
    final rank = user['rank'] as int;
    final name = user['name'] as String;
    final points = user['points'] as int;

    final color = switch (rank) {
      1 => Colors.amber,
      2 => Colors.grey,
      3 => const Color(0xFFCD7F32), // bronze shade
      _ => theme.colorScheme.primary,
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (rank == 1)
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Icon(Icons.emoji_events, color: Colors.amber, size: 36),
          ),
        Transform.translate(
          offset: Offset(0, offsetY),
          child: Column(
            children: [
              TopUserCard(
                name: name,
                points: points,
                rank: rank,
                color: color,
                // height: height,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
