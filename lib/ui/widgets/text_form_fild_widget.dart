import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool isObscure;
  final String? Function(String?) validator;
  final TextEditingController textEditingController;
  final bool? isMaxLines;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.isObscure,
    required this.validator,
    required this.textEditingController,
    this.isMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: isMaxLines == null ? 1 : null,
      // maxLines: null,
      obscureText: isObscure,
      controller: textEditingController,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.amber.shade800,
            width: 3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.amber.shade800,
            width: 3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.amber.shade800,
            width: 3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.amber.shade800,
            width: 3,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.amber.shade800,
            width: 3,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.amber.shade800,
            width: 3,
          ),
        ),
      ),
    );
  }
}
