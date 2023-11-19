import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key, 
    required this.name, 
    required this.icon,
    this.isPassword = false,
    this.isRequired = true,
    this.labelText = "",
    this.hintText = "",
    this.onEditingComplete,
    this.validator,
    required this.errorMessage,
  });

  final String name;
  final IconData icon;
  final bool isPassword;
  final bool isRequired;
  final String labelText;
  final String hintText;

  final String? Function(String?)? validator;
  final String errorMessage;

  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFDEDEDE),
        enabledBorder: _fieldBorder(color: Colors.white),
        focusedBorder: _fieldBorder(color: Colors.green),
        errorBorder: _fieldBorder(color: Colors.red),
        focusedErrorBorder: _fieldBorder(color: Colors.red),
        alignLabelWithHint: true
      ),
      validator: validator,
      onEditingComplete: onEditingComplete,
    );
  }
}

OutlineInputBorder _fieldBorder({required Color color}){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(width: 2.0, color: color),
  );
}