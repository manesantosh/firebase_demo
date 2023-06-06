// library imports
import 'package:flutter/material.dart';

// local imports
import 'package:firebase/navigation/route_generator.dart';
import 'package:firebase/screens/home_screen.dart';
import 'constants/constant_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: registerScreen,
      onGenerateRoute: CustomRouteGenerator.generateRoute,
      home: const HomeScreenState(),
    );
  }
}
