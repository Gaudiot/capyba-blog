import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key, required this.routeName, required this.child});
  final Widget child;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return SliderDrawer(
      slider: const _SliderView(),
      appBar: SliderAppBar(
        title: Text(routeName),
      ),
      child: child
    );
  }
}

class _SliderView extends StatelessWidget {
  const _SliderView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SliderTile(
          text: "Home",
          icon: FontAwesomeIcons.house,
          onTap: (){}
        ),
        _SliderTile(
          text: "Profile",
          icon: FontAwesomeIcons.user,
          onTap: (){}
        ),
        _SliderTile(
          text: "Log out",
          icon: FontAwesomeIcons.rightFromBracket,
          onTap: (){}
        ),
        _SliderTile(
          text: "Validate Email",
          icon: FontAwesomeIcons.envelopeCircleCheck,
          onTap: (){}
        ),
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