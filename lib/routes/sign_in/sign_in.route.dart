import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';

class SignInRoute extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final IFirebaseService firebaseService = FirebaseService();

  SignInRoute({super.key});

  void _submitForm() async{
    final currentState = _formKey.currentState!;
    if(currentState.saveAndValidate()){
      print("batata");
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
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(
              hintText: "email@example.com"
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required()
            ]),
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          FormBuilderTextField(
            name: 'password',
            decoration: const InputDecoration(
              hintText: "secret_password"
            ),
            obscureText: true,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required()
            ]),
            onEditingComplete: _submitForm,
          ),
          TextButton(
            onPressed: (){}, 
            child: const Text("Entrar")
          ),
          TextButton(
            onPressed: (){
              context.goNamed('signup');
            }, 
            child: const Text("Criar conta")
          )
        ],
      ),
    );
  }
}