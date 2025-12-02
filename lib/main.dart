import 'package:flutter/material.dart';
import 'package:hitster/screens/home.dart';
import 'package:hitster/screens/play_screen.dart';
import 'package:hitster/screens/rules_screen.dart';
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

void main() {

  ui_web.platformViewRegistry.registerViewFactory(
  'web-scanner-video',
  (int viewId) {
    final video = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..setAttribute('playsinline', 'true');
    return video;
  },
);

  runApp(MaterialApp(
    title: 'Hitster',
    home: const Home(),
    routes: {
      '/play': (context) => const PlayScreen(),
      '/rules': (context) => const RulesScreen(),
    },
  ));
}

