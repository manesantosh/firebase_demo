import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  late StreamController<int> _events;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _events = StreamController<int>();
    _events.add(60);
  }

  void _startTimer() {
    late Timer _timer;
    _counter = 60;
    // if (timer != null) {
    //   _timer.cancel();
    // }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : _timer.cancel();
      //});
      print(_counter);
      _events.add(_counter);
    });
  }

  Future<void> createAccount(BuildContext context) async {
    String emailAddress = emailController.text;
    String password = passwordController.text;
    print("email: $emailAddress, password: $password");
    try {
      final credential = await _auth
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      )
          .then((value) {
        alertDialog("Registration Successful...", null, homeScreen);
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

  Future<void> loginUsingCredentials(BuildContext context) async {
    String emailAddress = emailController.text;
    String password = passwordController.text;

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        try {
          final credential = await _auth
              .signInWithEmailAndPassword(
                  email: emailAddress, password: password)
              .then((value) {
            alertDialog("Login Successful...", null, homeScreen);
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

  Future<void> loginWithOTP(BuildContext context) async {
    print(phoneController.text);
    _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user!;

          print("user: ${result.user}");

          if (user != null) {
            alertDialog(
                "You are Logged in successfully", user.phoneNumber, null);
          } else {
            alertDialog("Error", "Error", null);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            alertDialog("Authentication Failed...",
                "The provided phone number is not valid.", null);
          } else {
            alertDialog(e.toString(), null, null);
          }
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                final defaultPinTheme = PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(30, 60, 87, 1),
                      fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(234, 239, 243, 1)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );

                final focusedPinTheme = defaultPinTheme.copyDecorationWith(
                  border:
                      Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
                  borderRadius: BorderRadius.circular(8),
                );

                final submittedPinTheme = defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration?.copyWith(
                    color: const Color.fromRGBO(234, 239, 243, 1),
                  ),
                );
                var smsCode = "";
                _startTimer();
                return AlertDialog(
                  title: const Text("OTP Validation"),
                  content: StreamBuilder<int>(
                      stream: _events.stream,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        print(snapshot.data.toString());
                        return SizedBox(
                          height: 215,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Pinput(
                                length: 6,
                                hapticFeedbackType:
                                    HapticFeedbackType.lightImpact,
                                showCursor: true,
                                onChanged: (value) {
                                  smsCode = value;
                                },
                              ),
                              Text('00:${snapshot.data.toString()}'),
                            ],
                          ),
                        );
                      }),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Verify phone"),
                      onPressed: () async {
                        final code = smsCode;
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);

                        UserCredential result =
                            await _auth.signInWithCredential(credential);

                        User user = result.user!;
                        if (user != null) {
                          Navigator.pop(context, 'Cancel');
                          alertDialog("You are Logged in successfully",
                              user.phoneNumber, null);
                        } else {
                          alertDialog("Error", "Error", null);
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  void alertDialog(String title, String? mainText, String? navigationString) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        iconPadding: EdgeInsets.zero,
        buttonPadding: const EdgeInsets.only(bottom: 10, right: 10),
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        contentPadding: EdgeInsets.zero,
        elevation: 5,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Visibility(
          visible: (mainText != null),
          replacement: const SizedBox.shrink(),
          child: Text(
            mainText ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              if (navigationString != null) {
                Navigator.pushNamed(context, navigationString);
              } else {
                Navigator.pop(context, 'Cancel');
              }
            },
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.screen == "Phone")
                              CustomTextFormField(
                                  inputTextStr: phone,
                                  errorTextStr: phoneError,
                                  inputRegex: RegExp(phoneRegex),
                                  customController: phoneController),
                            if (widget.screen != "Phone")
                              CustomTextFormField(
                                  inputTextStr: email,
                                  errorTextStr: emailError,
                                  inputRegex: RegExp(emailRegex),
                                  customController: emailController),
                            if (widget.screen != "Phone")
                              const SizedBox(
                                height: 20,
                              ),
                            if (widget.screen != "Phone")
                              CustomTextFormField(
                                  inputTextStr: password,
                                  errorTextStr: passwordError,
                                  inputRegex: RegExp(passwordRegex),
                                  customController: passwordController),
                            if (widget.screen == "Login")
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(forgotPassword)),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                                style: roundedButtonStyle,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    switch (widget.screen) {
                                      case "Login":
                                        loginUsingCredentials(context);
                                      case "Register":
                                        createAccount(context);
                                      case "Phone":
                                        loginWithOTP(context);
                                    }
                                  }
                                },
                                child: Text(
                                  (widget.screen == "Phone")
                                      ? ("Get OTP")
                                      : (widget.screen),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              "-------- Or ${(widget.screen == "Phone") ? ("sign up") : (widget.screen)} with --------",
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
                            Visibility(
                              visible: (widget.screen != "Phone"),
                              replacement: const SizedBox.shrink(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text((widget.screen == "Login")
                                      ? (dontHaveAccountStr)
                                      : (haveAnAccount)),
                                  TextButton(
                                      onPressed: () {
                                        (widget.screen == "Login")
                                            ? (Navigator.of(context)
                                                .popAndPushNamed(registerScreen,
                                                    arguments: "Register"))
                                            : (Navigator.of(context)
                                                .popAndPushNamed(loginScreen,
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
                              ),
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
