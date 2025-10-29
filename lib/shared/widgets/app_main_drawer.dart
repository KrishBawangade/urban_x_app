import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urban_x_app/core/models/drawer_item_model.dart';

class AppMainDrawer extends StatelessWidget {
  const AppMainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Minimal drawer items
    List<DrawerItemModel> drawerItemList = [
      DrawerItemModel(
        title: "Profile",
        icon: Icons.person,
        // pageWidget: const ProfilePage(),
        onClick: () {},
      ),
      DrawerItemModel(
        title: "Log Out",
        icon: Icons.logout,
        onClick: () async {
          // Add logout logic here
        },
      ),
    ];

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context); // Close drawer
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const ProfilePage(),
                      //   ),
                      // );
                    },
                    child: ListTile(
                      title: Text(currentUser?.displayName ?? "Guest"),
                      leading:
                          (currentUser?.photoURL ?? "").isEmpty
                              ? const Icon(Icons.account_circle, size: 50)
                              : ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: currentUser?.photoURL ?? "",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.account_circle,
                                        size: 50,
                                      ),
                                  placeholder:
                                      (context, url) =>
                                          const CircularProgressIndicator(),
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: drawerItemList.length,
              itemBuilder: (context, index) {
                var drawerItem = drawerItemList[index];
                return ListTile(
                  leading: Icon(drawerItem.icon),
                  title: Text(drawerItem.title),
                  onTap: () {
                    if (drawerItem.pageWidget != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => drawerItem.pageWidget!,
                        ),
                      );
                    } else {
                      drawerItem.onClick?.call();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
