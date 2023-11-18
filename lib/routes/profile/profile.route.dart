import 'package:flutter/material.dart';

import 'package:capyba_blog/shared/components/drawer_layout.dart';

class ProfileRoute extends StatelessWidget {
  const ProfileRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerLayout(
      routeName: "Profile",
      child: Container(
        color: Colors.cyan,
        child: const Center(
          child: Text("Página Profile"),
        ),
      )
    );
  }
}