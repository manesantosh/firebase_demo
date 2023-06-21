import 'package:firebase/constants/constant_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenState extends StatefulWidget {
  const HomeScreenState({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreenState> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueGrey,
        elevation: 5,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(loginScreen, arguments: "Login");
                },
                child: const Text("Login"),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(loginScreen, arguments: "Register");
                },
                child: const Text("Register"),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('signed out...')),
                  ));
                },
                child: const Text("LogOut"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
