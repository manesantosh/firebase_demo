import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;

  const CustomIconButton(
      {super.key, required this.buttonText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        size: 25,
        color: Colors.black,
      ),
      label: Text(
        buttonText,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: Colors.black))),
      ),
    );
  }
}
