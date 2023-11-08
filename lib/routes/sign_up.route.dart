import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:capyba_blog/services/firebase/IFirebaseService.dart';
import 'package:capyba_blog/services/firebase/implementations/FirebaseService.dart';
import 'package:go_router/go_router.dart';

class SignUpRoute extends StatelessWidget {
  final IFirebaseService firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormBuilderState>();

  SignUpRoute({super.key});

  Future<void> _submitForm() async{
    final currentState = _formKey.currentState!;
    if(currentState.saveAndValidate()){
      final userEmail = currentState.value['email'].toString();
      final userPassword = currentState.value['password'].toString();
      await firebaseService.signUp();
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
              FormBuilderValidators.required(),
              FormBuilderValidators.email()
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
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6)
            ]),
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          FormBuilderTextField(
            name: 'confirm password',
            decoration: const InputDecoration(
              hintText: "secret_password_again"
            ),
            obscureText: true,
            validator: (value){
              if(value == null || value.isEmpty || _formKey.currentState!.fields['password']!.value != value){
                return "Passwords do not match";
              }
              return null;
            },
            onEditingComplete: _submitForm,
          ),
          TextButton(
            onPressed: _submitForm, 
            child: const Text("Cadastrar")
          ),
          TextButton(
            onPressed: (){
              context.pushNamed('signin');
            },
            child: const Text("Já tenho conta")
          )
        ],
      ),
    );
  }
}