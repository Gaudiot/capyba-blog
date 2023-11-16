import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: "https://cdn.discordapp.com/attachments/1163499621700608030/1174674179635826738/capyba_reading.png?ex=65687394&is=6555fe94&hm=9a1e4344a5c6f943da76096cbfd4e5ff609d8f844dfceff5847a321b11bda421&",
          height: 270,
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _WelcomeButton(
              icon: FontAwesomeIcons.userPlus,
              text: "Create Account",
              onTap: () => {
                context.pushNamed("signup")
              }
            ),
            const SizedBox(width: 30),
            _WelcomeButton(
              icon: FontAwesomeIcons.rightToBracket,
              text: "Already Registered",
              onTap: () => {
                context.pushNamed("signin")
              }
            ),
          ],
        )
      ],
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({super.key, required this.icon, required this.text, required this.onTap});
  final double _dimension = 150.0;

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.amber,
          width: 2.5
        )
      ),
      elevation: 10,
      child: SizedBox.square(
        dimension: _dimension,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(height: 5),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}