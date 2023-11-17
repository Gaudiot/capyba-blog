import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key, required this.routeName, required this.child});
  final Widget child;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return SliderDrawer(
      slider: _SliderView(),
      appBar: SliderAppBar(
        title: Text(routeName),
      ),
      child: child
    );
  }
}

class _SliderView extends StatelessWidget {
  _SliderView({super.key});
  final IFirebaseService firebaseService = FirebaseService();

  Future<void> logout(BuildContext context) async {
    await firebaseService.logout();
    if(context.mounted){
      context.goNamed("welcome");
    }
  }

  Future<void> sendValidationEmail() async {
    final isEmailSent = await firebaseService.sendValidationEmail();
  }

  bool isUserVerified(){
    return firebaseService.isUserVerified();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SliderTile(
          text: "Home",
          icon: FontAwesomeIcons.house,
          onTap: (){
            context.pushNamed("home");
          }
        ),
        _SliderTile(
          text: "Profile",
          icon: FontAwesomeIcons.user,
          onTap: (){
            context.pushNamed("profile");
          }
        ),
        _SliderTile(
          text: "Log out",
          icon: FontAwesomeIcons.rightFromBracket,
          onTap: () => logout(context)
        ),
        !isUserVerified() ? _SliderTile(
          text: "Validate Email",
          icon: FontAwesomeIcons.envelopeCircleCheck,
          onTap: sendValidationEmail
        ) : const SizedBox.shrink(),
      ],
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({super.key, required this.text, required this.icon, required this.onTap});

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}