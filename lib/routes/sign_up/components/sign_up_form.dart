import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/shared/components/form_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, required this.updateParent});
  final Function updateParent;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _submitForm() async {
    final currentState = _formKey.currentState!;
    if(currentState.saveAndValidate()){
      final userUsername = currentState.value['username'].toString();
      final userEmail = currentState.value['email'].toString();
      final userPassword = currentState.value['password'].toString();
      final user = UserDTO(username: userUsername, email: userEmail, password: userPassword);
      widget.updateParent(user);
    }else{
      print("print: ${_formKey.currentState?.value['email'].toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: "https://cdn.discordapp.com/attachments/1034282841766383697/1175077393606660117/capyba_signup.png?ex=6569eb1a&is=6557761a&hm=c05f04ce80588ebe1b3bc1a47702b6aff21ed2404d9adc09b0bae3644018bbc6&",
                height: 300,
              ),
              const _UsernameField(),
              const SizedBox(height: 5),
              const _EmailField(),
              const SizedBox(height: 5),
              const _PasswordField(),
              const SizedBox(height: 5),
              _ConfirmPassword(
                formKey: _formKey,
                onComplete: () => _submitForm()
              ),
              ElevatedButton(
                onPressed: _submitForm, 
                child: const Text("Sign Up")
              ),
              const Divider(),
              TextButton(
                onPressed: (){
                  context.pushNamed('signin');
                },
                child: const Text("Already have an account?")
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField({super.key});

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      name: "username",
      hintText: "My cool username",
      labelText: "Username",
      icon: FontAwesomeIcons.user, 
      errorMessage: "Username must have between 6 and 20 characters",
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(6),
        FormBuilderValidators.maxLength(20),
        (username){
          final RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9_-_ ]{6,20}$");
          if(username != null && !usernameRegex.hasMatch(username)){
            return "Username can only contain letters and numbers";
          }
          return null;
        }
      ]),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return FormTextField(
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
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      name: "password",
      hintText: "secret_password",
      labelText: "Password",
      icon: FontAwesomeIcons.lock,
      isPassword: true,
      errorMessage: "Password must contain at least 6 characters",
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(6)
      ]),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class _ConfirmPassword extends StatelessWidget {
  const _ConfirmPassword({super.key, required this.formKey, required this.onComplete});
  final GlobalKey<FormBuilderState> formKey;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      name: "repeat_password",
      hintText: "secret_password",
      labelText: "Repeat Password",
      icon: FontAwesomeIcons.lock,
      isPassword: true,
      errorMessage: "Passwords do not match",
      validator: (value){
        if(value == null || value.isEmpty || formKey.currentState!.fields['password']!.value != value){
          return "Passwords do not match";
        }
        return null;
      },
      onEditingComplete: onComplete,
    );
  }
}