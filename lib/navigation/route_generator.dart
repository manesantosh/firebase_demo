import 'package:flutter/material.dart';
import '../screens/register_screen.dart';
import '../constants/constant_strings.dart';

class CustomRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case registerScreen:
        return MaterialPageRoute(builder: (_) => Register());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => Register());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => Register());
      default:
        return MaterialPageRoute(builder: (_) => Register());
    }
  }
}
