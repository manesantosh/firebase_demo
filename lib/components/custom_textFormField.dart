import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String inputTextStr;
  final RegExp inputRegex;
  final String errorTextStr;
  final TextEditingController customController;

  const CustomTextFormField(
      {super.key,
      required this.inputTextStr,
      required this.errorTextStr,
      required this.inputRegex,
      required this.customController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: customController,
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
      validator: (String? value) {
        print("$value, text:${customController.text}");
        if (!inputRegex.hasMatch(customController.text)) {
          return errorTextStr;
        }
        return null;
      },
    );
  }
}
