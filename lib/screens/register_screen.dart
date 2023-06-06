import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/custom_iconButton.dart';
import '../components/custom_textFormField.dart';
import '../constants/constant_strings.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final ButtonStyle roundedButtonStyle = ButtonStyle(
    splashFactory: InkRipple.splashFactory,
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Colors.green))),
    padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
    elevation: MaterialStateProperty.all(8),
    backgroundColor:
        MaterialStateColor.resolveWith((states) => Colors.greenAccent),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(15),
          width: double.maxFinite,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    signUp,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    signUpMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const CustomTextFormField(
                                inputTextStr: email,
                                errorTextStr: emailError,
                                inputRegex: emailRegex),
                            const SizedBox(
                              height: 20,
                            ),
                            const CustomTextFormField(
                                inputTextStr: password,
                                errorTextStr: passwordError,
                                inputRegex: passwordRegex),
                            TextButton(
                                onPressed: () {},
                                child: const Text(forgotPassword)),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                                style: roundedButtonStyle,
                                onPressed: () {},
                                child: const Text(
                                  signIn,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              orSignInWith,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomIconButton(
                                  buttonText: google,
                                  icon: Icons.g_mobiledata_rounded,
                                ),
                                CustomIconButton(
                                  buttonText: apple,
                                  icon: Icons.apple_rounded,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(dontHaveAccountStr),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      registerNow,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
