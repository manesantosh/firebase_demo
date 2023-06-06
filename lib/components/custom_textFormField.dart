import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String inputTextStr;
  final String inputRegex;
  final String errorTextStr;

  const CustomTextFormField(
      {super.key,
      required this.inputTextStr,
      required this.errorTextStr,
      required this.inputRegex});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: inputTextStr,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, color: Colors.grey)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, color: Colors.greenAccent)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, color: Colors.redAccent))),
    );
  }
}
