import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData? icon;
  final bool password;

  const LoginForm(
      {super.key,
      this.label,
      this.hint,
      this.errorMessage,
      this.validator,
      this.icon,
      this.password = false,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(40));

    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: password,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 14, 105, 179))),
        errorBorder:
            border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        focusedErrorBorder:
            border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        isDense: true,
        label: label != null ? Text(label!) : null,
        hintText: hint,
        focusColor: const Color.fromARGB(255, 14, 105, 179),
        prefixIcon: Icon(
          icon,
          size: 25.0,
        ),
        errorText: errorMessage,
      ),
    );
  }
}
