import 'package:flutter/material.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/my_issues_header.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/my_issues_list.dart';
import 'package:urban_x_app/features/my_issues/presentation/widgets/my_issues_filter_bar.dart';
import 'package:urban_x_app/shared/widgets/app_main_drawer.dart';
import 'package:urban_x_app/shared/widgets/glass_sliver_app_bar.dart';

class MyIssuesPage extends StatefulWidget {
  const MyIssuesPage({super.key});

  @override
  State<MyIssuesPage> createState() => _MyIssuesPageState();
}

class _MyIssuesPageState extends State<MyIssuesPage> {
  String selectedFilter = 'All';

  void _onFilterChanged(String filter) {
    setState(() => selectedFilter = filter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      drawer: const AppMainDrawer(),
      body: CustomScrollView(
        slivers: [
          // 🪟 Glass Sliver App Bar
          GlassSliverAppBar(
            title: Text(
              "My Reported Issues",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),

          // 📊 Summary / Stats Section
          const SliverToBoxAdapter(
            child: MyIssuesHeader(),
          ),

          // 🎛️ Filter Bar Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: MyIssuesFilterBar(
                selectedFilter: selectedFilter,
                onFilterChanged: _onFilterChanged,
              ),
            ),
          ),

          // 🧾 Issues List (Filtered)
          MyIssuesList(selectedFilter: selectedFilter),
        ],
      ),
    );
  }
}
