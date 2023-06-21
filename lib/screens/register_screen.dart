import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/custom_iconButton.dart';
import '../components/custom_textFormField.dart';
import '../constants/constant_strings.dart';

class Register extends StatefulWidget {
  final String screen;

  const Register({super.key, required this.screen});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> createAccount(BuildContext context) async {
    String emailAddress = emailController.text;
    String password = passwordController.text;
    print("email: $emailAddress, password: $password");
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      )
          .then((value) {
        alertDialog("Registration Successful...", "", homeScreen);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        alertDialog(
            "Registration Failed...",
            "The password provided is too weak.\n Please provide a strong password",
            null);
      } else if (e.code == 'email-already-in-use') {
        alertDialog(
            "Registration Failed...",
            "The account already exists for that email.\n Please try with another email",
            null);
      }
    } catch (e) {
      alertDialog("Registration Failed...", e.toString(), null);
    }
  }

  void alertDialog(String title, String mainText, String? navigationString) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Text(
          mainText,
          style: const TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (navigationString != null) {
                Navigator.pushNamed(context, navigationString);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> loginUsingCredentials(BuildContext context) async {
    String emailAddress = emailController.text;
    String password = passwordController.text;

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailAddress, password: password)
              .then((value) {
            alertDialog("Login Successful...", "", homeScreen);
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            alertDialog(
                "Login Failed...", "No user found for that email.", null);
          } else if (e.code == 'wrong-password') {
            alertDialog("Login Failed...",
                "Wrong password provided for that user.", null);
          }
        }
      } else {
        alertDialog("Login Failed...", 'User is signed in!', null);
      }
    });
  }

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
                  Text(
                    widget.screen,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Hey, Enter your details to ${widget.screen} \n to your account",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                                inputTextStr: email,
                                errorTextStr: emailError,
                                inputRegex: RegExp(emailRegex),
                                customController: emailController),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                                inputTextStr: password,
                                errorTextStr: passwordError,
                                inputRegex: RegExp(passwordRegex),
                                customController: passwordController),
                            TextButton(
                                onPressed: () {},
                                child: Visibility(
                                    visible: (widget.screen == "Login"),
                                    child: const Text(forgotPassword))),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                                style: roundedButtonStyle,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    (widget.screen == "Login")
                                        ? (loginUsingCredentials(context))
                                        : (createAccount(context));
                                  }
                                },
                                child: Text(
                                  widget.screen,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              "-------- Or ${widget.screen} with --------",
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
                                Text((widget.screen == "Login")
                                    ? (dontHaveAccountStr)
                                    : (haveAnAccount)),
                                TextButton(
                                    onPressed: () {
                                      (widget.screen == "Login")
                                          ? (Navigator.of(context).pushNamed(
                                              registerScreen,
                                              arguments: "Register"))
                                          : (Navigator.of(context).pushNamed(
                                              loginScreen,
                                              arguments: "Login"));
                                    },
                                    child: Text(
                                      (widget.screen == "Login")
                                          ? (registerNow)
                                          : (logInTxt),
                                      style: const TextStyle(
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

  // button style
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
}
