// library imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// local imports
import 'package:firebase/navigation/route_generator.dart';
import 'constants/constant_strings.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      initialRoute: homeScreen,
      onGenerateRoute: CustomRouteGenerator.generateRoute,
    );
  }
}
