// Web implementation which registers platform view factories.
// This file is compiled only when `dart.library.html` is available.

// Use JS interop to access platformViewRegistry on the global window object.
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart';

bool registerWebViewFactory(String viewType, dynamic Function(int) factory) {
  // Use JS interop to check window.platformViewRegistry directly. Some
  // embedder configurations don't expose a dart:ui platformViewRegistry
  // symbol, so referencing it at compile-time can fail. Accessing the
  // global via JS interop avoids that compile-time dependency.
  final registry = js_util.getProperty(html.window, 'platformViewRegistry');
  if (registry != null) {
    js_util.callMethod(registry, 'registerViewFactory', [viewType, factory]);
    return true;
  }

  debugPrint('platformViewRegistry not available on window.');
  return false;
}
