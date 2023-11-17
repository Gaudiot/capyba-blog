import 'package:cached_network_image/cached_network_image.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';
import 'package:flutter/material.dart';
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
        const SizedBox(height: 40),
        const SizedBox(width: 30),
        SignInButton(
          buttonType: ButtonType.mail,
          buttonSize: ButtonSize.medium,
          btnText: "Sign in with email",
          onPressed: () => context.pushNamed('signup')
        ),
        SignInButton(
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
        ),
        const Divider(
          color: Colors.black,
          thickness: 1,
          indent: 50,
          endIndent: 50,
        ),
        TextButton(
          onPressed: () => context.pushNamed('signup'),
          child: const Text("Create account", style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.green
          ))
        )
      ],
    );
  }
}