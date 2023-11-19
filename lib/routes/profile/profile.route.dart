import 'package:cached_network_image/cached_network_image.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:capyba_blog/shared/components/drawer_layout.dart';

class ProfileRoute extends StatefulWidget {
  const ProfileRoute({super.key});

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  final IFirebaseService firebaseService = FirebaseService();
  User? user;
  
  @override
  void initState() {
    user = firebaseService.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerLayout(
      routeName: "Profile",
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: (user?.photoURL ?? "https://picsum.photos/200"),
            placeholder: (context, url) => const CircularProgressIndicator(),
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover
                  ),
                ),
              );
            },
          ),
          Text(user?.displayName ?? "No username found"),
          Text(user?.email ?? "No email found"),
        ],
      )
    );
  }
}