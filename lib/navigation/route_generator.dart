import 'package:firebase/screens/home_screen.dart';
import 'package:firebase/screens/pin_screen.dart';
import 'package:flutter/material.dart';
import '../screens/register_screen.dart';
import '../constants/constant_strings.dart';

class CustomRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case registerScreen:
        final args = settings.arguments;
        if (args is String) {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => Register(screen: args),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c));
        }
        return _errorRoute();

      case loginScreen:
        if (args is String) {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => Register(screen: args),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c));
        }
        return _errorRoute();

      case phoneScreen:
        if (args is String) {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => Register(screen: args),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c));
        }
        return _errorRoute();

      case pinScreen:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => const PinScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));

      case homeScreen:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => const HomeScreenState(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));

      default:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => const HomeScreenState(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
