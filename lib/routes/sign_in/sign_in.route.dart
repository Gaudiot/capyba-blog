import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:go_router/go_router.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/shared/components/form_text_field.dart';
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
      await firebaseService.signIn(user);
      if(context.mounted){
        context.goNamed('home');
      }
    }else{
      debugPrint("Incorrect credentials, try again.");
    }
  }

  Future<void> _resetPassword(BuildContext context) async{
    final currentState = _formKey.currentState!;
    final userEmail = currentState.value['email'].toString();
    
    final RegExp emailRegex = RegExp(r'[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+');
    if(emailRegex.hasMatch(userEmail)){
      await firebaseService.resetPassword(email: userEmail);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Reset password email sent!"
        )
      );
    }else{
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Account verification email sent!"
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: "https://cdn.discordapp.com/attachments/1034282841766383697/1175077393606660117/capyba_signup.png?ex=6569eb1a&is=6557761a&hm=c05f04ce80588ebe1b3bc1a47702b6aff21ed2404d9adc09b0bae3644018bbc6&",
              height: 300,
            ),
            const _EmailField(),
            const SizedBox(height: 5),
            _PasswordField(
              onComplete: () => _submitForm(context),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => _resetPassword(context),
                  child: const Text("Forgot password?")
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _submitForm(context), 
                  child: const Text("Sign In")
                ),
              ],
            ),
            const Divider(),
            TextButton(
              onPressed: (){
                context.pushNamed('signup');
              }, 
              child: const Text("Create account")
            )
          ],
        ),
      ),
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
  const _PasswordField({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      name: "password",
      hintText: "secret_password",
      labelText: "Password",
      icon: FontAwesomeIcons.lock,
      isPassword: true,
      errorMessage: "Enter a password",
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      onEditingComplete: onComplete,
    );
  }
}