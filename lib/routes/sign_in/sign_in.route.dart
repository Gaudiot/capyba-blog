import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/shared/components/form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';

class SignInRoute extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final IFirebaseService firebaseService = FirebaseService();

  SignInRoute({super.key});

  void _submitForm(BuildContext context) async {
    final currentState = _formKey.currentState!;
    if(currentState.saveAndValidate()){
      final userEmail = currentState.value['email'].toString();
      final userPassword = currentState.value['password'].toString();
      final user = UserDTO(email: userEmail, password: userPassword);
      await firebaseService.login(user);
      if(context.mounted){
        context.goNamed('home');
      }
    }else{
      print("print: ${_formKey.currentState?.value['email'].toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormTextField(
            name: "email",
            hintText: "email@example.com",
            labelText: "Email",
            icon: FontAwesomeIcons.envelope,
            errorMessage: "Enter a valid email address",
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email()
            ]),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          FormTextField(
            name: "password",
            hintText: "secret_password",
            labelText: "Email",
            icon: FontAwesomeIcons.lock,
            isPassword: true,
            errorMessage: "Enter a password",
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            onEditingComplete: () => _submitForm(context),
          ),
          TextButton(
            onPressed: () => _submitForm(context), 
            child: const Text("Entrar")
          ),
          TextButton(
            onPressed: (){
              context.pushNamed('signup');
            }, 
            child: const Text("Criar conta")
          )
        ],
      ),
    );
  }
}