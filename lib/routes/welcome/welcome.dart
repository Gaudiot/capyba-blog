import 'package:cached_network_image/cached_network_image.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_button/sign_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: "https://cdn.discordapp.com/attachments/1163499621700608030/1174674179635826738/capyba_reading.png?ex=65687394&is=6555fe94&hm=9a1e4344a5c6f943da76096cbfd4e5ff609d8f844dfceff5847a321b11bda421&",
          height: 270,
        ),
        const SizedBox(height: 20),
        const _SignUpButton(),
        const Divider(),
        const _SignInEmailButton(),
        const SizedBox(height: 5),
        const _SignInGoogleButton()
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () => context.pushNamed('signup'),
        child: const Row(
          children: [
            Icon(FontAwesomeIcons.userPlus, size: 20),
            SizedBox(width: 10),
            Text("Create account"),
          ],
        )
      ),
    );
  }
}

class _SignInEmailButton extends StatelessWidget {
  const _SignInEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.mail,
      buttonSize: ButtonSize.medium,
      btnText: "Sign in with email",
      onPressed: () => context.pushNamed('signin')
    );
  }
}

class _SignInGoogleButton extends StatelessWidget {
  const _SignInGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.google,
      buttonSize: ButtonSize.medium,
      btnText: "Sign in with google",
      onPressed: () async {
        final IFirebaseService firebaseService = FirebaseService();
        final user = await firebaseService.signInWithGoogle();

        if(user != null && context.mounted){
          context.goNamed('home');
        }
      }
    );
  }
}