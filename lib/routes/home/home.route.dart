import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capyba_blog/shared/components/drawer_layout.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';

class HomeRoute extends StatelessWidget {
  HomeRoute({super.key});
  final IFirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return DrawerLayout(
      routeName: "Home",
      child: Center(
        child: TextButton(
          onPressed: () async {
            await firebaseService.logout();
            if(context.mounted){
              context.goNamed('signup');
            }
          },
          child: const Text("Logout"),
        ),
      )
    );
  }
}