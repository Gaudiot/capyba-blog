import 'package:flutter/material.dart';

import 'package:capyba_blog/shared/components/drawer_layout.dart';

class RestrictedRoute extends StatelessWidget {
  const RestrictedRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerLayout(
      routeName: "Restricted",
      child: Container(
        color: Colors.pink,
        child: const Center(
          child: Text("Página Restricted"),
        ),
      )
    );
  }
}