import 'package:flutter/material.dart';
import 'package:hitster/screens/home.dart';
import 'package:hitster/screens/play_screen.dart';
import 'package:hitster/screens/rules_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Hitster',
    home: const Home(),
    routes: {
      '/play': (context) => const PlayScreen(),
      '/rules': (context) => const RulesScreen(),
    },
  ));
}

