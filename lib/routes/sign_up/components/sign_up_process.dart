import 'package:capyba_blog/routes/sign_in/sign_in.route.dart';
import 'package:capyba_blog/routes/sign_up/sign_up.route.dart';
import 'package:capyba_blog/services/firebase/IFirebaseService.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';
import 'package:capyba_blog/shared/components/base_layout.dart';
import 'package:flutter/material.dart';

class SignUpProcess extends StatefulWidget {
  const SignUpProcess({super.key});

  @override
  State<SignUpProcess> createState() => _SignUpProcessState();
}

class _SignUpProcessState extends State<SignUpProcess> {
  Future<dynamic>? userRegistration;
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    userRegistration = firebaseService.signUp();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: FutureBuilder(
        future: userRegistration, 
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if(snapshot.hasError){
                return const SignUpRoute();
              }
              return SignInRoute();
            default:
              return SignInRoute();
          }
        },
      ),
    );
  }
}