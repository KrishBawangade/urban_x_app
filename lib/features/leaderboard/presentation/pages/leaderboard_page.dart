import 'package:flutter/material.dart';
import 'package:urban_x_app/features/leaderboard/presentation/widgets/leaderboard_list.dart';
import 'package:urban_x_app/features/leaderboard/presentation/widgets/top_users_section.dart';
import 'package:urban_x_app/shared/widgets/app_main_drawer.dart';
import 'package:urban_x_app/shared/widgets/glass_sliver_app_bar.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppMainDrawer(),
      body: CustomScrollView(
        slivers: [
          GlassSliverAppBar(
            title: Text(
              "Leaderboard",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopUsersSection(),
                  const SizedBox(height: 20),
                  Text(
                    "All Rankings",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const LeaderboardList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
