import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSliverAppBar extends StatelessWidget {
  final Widget? title;
  final List<Widget>? actions;
  final double? expandedHeight;
  final bool? centerTitle;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;

  const GlassSliverAppBar({
    super.key,
    this.title,
    this.actions,
    this.expandedHeight = kToolbarHeight,
    this.centerTitle = true,
    this.profileImageUrl,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    const double blurSigma = 8.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      stretch: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Navigator.of(context).canPop()
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(color: Colors.transparent),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(
                  color: Colors.white.withAlpha(27),
                ),
              ),
            ),
          ],
        ),
      ),
      title: title,
      centerTitle: centerTitle,
      actions: [
        if (actions != null) ...actions!,
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: onProfileTap ??
                () {
                  // Default navigation (you can replace with your own route)
                  Navigator.of(context).pushNamed('/profile');
                },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.withAlpha(150),
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
