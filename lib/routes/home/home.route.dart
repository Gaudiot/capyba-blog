import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeRoute extends StatelessWidget {
  HomeRoute({super.key});
  final IFirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          await firebaseService.logout();
          if(context.mounted){
            context.goNamed('signup');
          }
        },
        child: const Text("Logout"),
      ),
    );
  }
}