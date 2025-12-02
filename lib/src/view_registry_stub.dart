// Stub implementation used on non-web platforms. The real implementation
// that references `ui.platformViewRegistry` is only used with
// conditional imports when `dart.library.html` is available.

/// Return false; nothing was registered on non-web platforms.
bool registerWebViewFactory(String viewType, dynamic Function(int) factory) {
  return false;
}
