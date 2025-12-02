import 'package:flutter/material.dart';
import 'package:hitster/screens/home.dart';
import 'package:hitster/screens/play_screen.dart';
import 'package:hitster/screens/rules_screen.dart';
// No direct HTML or ui_web registration in main. Platform views are
// registered from the PlayScreen when needed.

void main() {

  // The PlayScreen registers the platform view factory when it initializes.
  // We intentionally avoid calling platformViewRegistry here to prevent
  // compile-time platform-specific dependencies in the app entrypoint.

  runApp(MaterialApp(
    title: 'Hitster',
    home: const Home(),
    routes: {
      '/play': (context) => const PlayScreen(),
      '/rules': (context) => const RulesScreen(),
    },
  ));
}

