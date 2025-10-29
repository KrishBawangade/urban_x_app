import 'package:flutter/material.dart';
import 'leaderboard_list_item.dart';

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Sneha Patil', 'points': 790, 'rank': 4},
      {'name': 'Rahul Deshmukh', 'points': 775, 'rank': 5},
      {'name': 'Meera Shah', 'points': 760, 'rank': 6},
      {'name': 'Aditya Verma', 'points': 748, 'rank': 7},
      {'name': 'Priya Nair', 'points': 740, 'rank': 8},
      {'name': 'Karan Singh', 'points': 732, 'rank': 9},
      {'name': 'Tanya Joshi', 'points': 720, 'rank': 10},
      {'name': 'Ravi Kumar', 'points': 708, 'rank': 11},
      {'name': 'Neha Mehta', 'points': 700, 'rank': 12},
      {'name': 'Sahil Khan', 'points': 688, 'rank': 13},
      {'name': 'Aditi Iyer', 'points': 675, 'rank': 14},
      {'name': 'Vikram Choudhary', 'points': 662, 'rank': 15},
      {'name': 'Irfan Sheikh', 'points': 655, 'rank': 16},
      {'name': 'Pooja Agarwal', 'points': 640, 'rank': 17},
      {'name': 'Harshita Jain', 'points': 630, 'rank': 18},
    ];

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return LeaderboardListItem(
          name: user['name'] as String,
          points: user['points'] as int,
          rank: user['rank'] as int,
        );
      },
    );
  }
}
