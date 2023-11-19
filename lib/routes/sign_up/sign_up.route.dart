import 'package:flutter/material.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/routes/sign_up/components/sign_up_form.dart';
import 'package:capyba_blog/routes/sign_up/components/sign_up_camera.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({super.key});

  @override
  State<SignUpRoute> createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  int signUpState = 0;
  UserDTO? user;

  void nextState(UserDTO? updatedUser){
    setState(() {
      signUpState += 1;
      user = updatedUser;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    switch (signUpState) {
      case 0:
        return SignUpForm(updateParent: nextState);
      case 1:
        return SignUpCamera(user: user!);
      default:
        return const Placeholder();
    }
  }
}