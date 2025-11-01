import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urban_x_app/shared/widgets/app_main_drawer.dart';
import 'package:urban_x_app/shared/widgets/glass_sliver_app_bar.dart';
import '../widgets/issue_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppMainDrawer(),
      body: CustomScrollView(
        slivers: [
          const GlassSliverAppBar(
            title: Text(
              "Nearby Issues",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),

          // Dynamic Search + Filter Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _AnimatedSearchFilterHeaderDelegate(),
          ),

          // Scrollable Issue List
          const SliverPadding(
            padding: EdgeInsets.only( bottom: 100, left: 8, right: 8),
            sliver: IssueList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          await context.pushNamed('add_issue');
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Issue"),
      ),
    );
  }
}

class _AnimatedSearchFilterHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 125;
  @override
  double get maxExtent => 125;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color bgColor = overlapsContent? Colors.white : Colors.transparent;
    final Color searchFilterBgColor = overlapsContent? colorScheme.surfaceContainerHighest : Colors.white;

    final double cornerRadius = overlapsContent? 24: 0;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(cornerRadius),
        bottomRight: Radius.circular(cornerRadius),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        color:  bgColor,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        curve: Curves.easeOutExpo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Row
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_rounded,
                    size: 18, color: Colors.redAccent),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Wardha Road, Somalwada, Nagpur, Maharashtra 440025 (Within 2km)",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
      
            // Search and Filter Row
            Row(
              children: [
                // Search bar
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search issues...",
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: searchFilterBgColor,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Filter button
                Container(
                  decoration: BoxDecoration(
                    color: searchFilterBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt_rounded),
                    onPressed: () {
                      // TODO: open filter bottom sheet
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(
          covariant _AnimatedSearchFilterHeaderDelegate oldDelegate) =>
      true;
}
