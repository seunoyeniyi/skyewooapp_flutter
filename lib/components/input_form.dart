import 'package:flutter/material.dart';
import 'package:skyewooapp/app_colors.dart';

class InputForm<T> extends StatefulWidget {
  const InputForm({
    Key? key,
    this.keyboardType = TextInputType.text,
    this.hintText = "",
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.validator,
  }) : super(key: key);

  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;

  final String? Function(String?)? validator;

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  String? val(String val) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColors.hover)),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: widget.autocorrect,
          validator: widget.validator,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
          ),
        ),
      ),
    );
  }
}
