import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:ui_web' as ui_web;
import 'dart:async';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  html.VideoElement? _videoElement;
  html.CanvasElement? _canvasElement;
  html.MediaStream? _stream;
  Timer? _scanTimer;
  bool _hasScanned = false;
  bool _isInitialized = false;
  String? _error;
  bool _useBarcodeDetector = false;
  final String _viewId = 'camera-view-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _loadJsQR();
    _registerViewFactory();
    _initializeCamera();
  }

  @override
  void dispose() {
    _stopCamera();
    _scanTimer?.cancel();
    super.dispose();
  }

  void _loadJsQR() {
    // Inject jsQR library for iOS/Safari compatibility
    if (html.document.getElementById('jsqr-script') == null) {
      final script = html.ScriptElement()
        ..id = 'jsqr-script'
        ..src = 'https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js'
        ..async = true;
      html.document.head!.append(script);
    }
  }

  void _registerViewFactory() {
    try {
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..setAttribute('playsinline', 'true') // Important for iOS
        ..setAttribute('webkit-playsinline', 'true') // Important for iOS
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      // Create canvas for jsQR (hidden, used for image processing)
      _canvasElement = html.CanvasElement();

      ui_web.platformViewRegistry.registerViewFactory(
        _viewId,
        (int viewId) => _videoElement!,
      );
    } catch (e) {
      debugPrint('View factory registration error: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Check if BarcodeDetector is supported (Chrome desktop, Edge)
      final barcodeDetectorSupported = js_util.hasProperty(html.window, 'BarcodeDetector');
      _useBarcodeDetector = barcodeDetectorSupported;
      
      debugPrint('BarcodeDetector supported: $_useBarcodeDetector');

      if (_videoElement == null) {
        setState(() {
          _error = 'Video element not initialized';
        });
        return;
      }

      // Request camera access with iOS-compatible constraints
      final constraints = {
        'video': {
          'facingMode': {'ideal': 'environment'}, // back camera preferred
          'width': {'ideal': 1280, 'max': 1920},
          'height': {'ideal': 720, 'max': 1080},
        },
        'audio': false,
      };

      try {
        _stream = await html.window.navigator.mediaDevices!.getUserMedia(constraints);
      } catch (e) {
        debugPrint('Back camera not available, trying any camera: $e');
        // Fallback for devices without back camera
        final fallbackConstraints = {
          'video': true,
          'audio': false,
        };
        _stream = await html.window.navigator.mediaDevices!.getUserMedia(fallbackConstraints);
      }

      _videoElement!.srcObject = _stream;
      
      // Wait for video to be ready (critical for iOS)
      await _videoElement!.onLoadedMetadata.first;
      await _videoElement!.play();

      setState(() {
        _isInitialized = true;
      });

      debugPrint('Camera initialized, video dimensions: ${_videoElement!.videoWidth}x${_videoElement!.videoHeight}');

      // Wait longer for iOS to ensure video is fully ready
      await Future.delayed(const Duration(milliseconds: 1000));
      _startScanning();
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize camera: $e\n\nPlease ensure:\n- Camera permissions are granted\n- You are accessing via HTTPS\n- Camera is not in use by another app';
      });
      debugPrint('Camera initialization error: $e');
    }
  }

  void _startScanning() {
    // Scan every 300ms for better performance
    _scanTimer = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      if (_hasScanned || _videoElement == null) return;
      
      if (_useBarcodeDetector) {
        await _detectBarcodeWithNativeAPI();
      } else {
        await _detectBarcodeWithJsQR();
      }
    });
  }

  Future<void> _detectBarcodeWithNativeAPI() async {
    try {
      final barcodeDetector = js_util.callConstructor(
        js_util.getProperty(html.window, 'BarcodeDetector'),
        [js_util.jsify({'formats': ['qr_code']})],
      );

      final barcodes = await js_util.promiseToFuture(
        js_util.callMethod(barcodeDetector, 'detect', [_videoElement]),
      );

      final barcodeList = js_util.dartify(barcodes) as List;

      if (barcodeList.isNotEmpty && !_hasScanned) {
        final firstBarcode = barcodeList.first as Map;
        final rawValue = firstBarcode['rawValue'] as String?;

        if (rawValue != null && rawValue.isNotEmpty) {
          _handleDetectedCode(rawValue);
        }
      }
    } catch (e) {
      debugPrint('Native barcode detection error: $e');
    }
  }

  Future<void> _detectBarcodeWithJsQR() async {
    try {
      // Check if jsQR is loaded
      if (!js_util.hasProperty(html.window, 'jsQR')) {
        return; // Library not loaded yet
      }

      final video = _videoElement!;
      
      // Skip if video not ready
      if (video.readyState != html.MediaElement.HAVE_ENOUGH_DATA) {
        return;
      }

      final canvas = _canvasElement!;
      final width = video.videoWidth;
      final height = video.videoHeight;

      if (width == 0 || height == 0) return;

      // Set canvas size to match video
      canvas.width = width;
      canvas.height = height;

      final context = canvas.getContext('2d') as html.CanvasRenderingContext2D;
      context.drawImageScaled(video, 0, 0, width, height);

      // Get image data
      final imageData = context.getImageData(0, 0, width, height);

      // Call jsQR
      final jsQR = js_util.getProperty(html.window, 'jsQR');
      final code = js_util.callMethod(
        jsQR,
        'default',
        [imageData.data, width, height, js_util.jsify({'inversionAttempts': 'dontInvert'})],
      );

      if (code != null) {
        final data = js_util.getProperty(code, 'data') as String?;
        if (data != null && data.isNotEmpty && !_hasScanned) {
          _handleDetectedCode(data);
        }
      }
    } catch (e) {
      debugPrint('jsQR detection error: $e');
    }
  }

  void _handleDetectedCode(String code) {
    setState(() {
      _hasScanned = true;
    });
    debugPrint('QR code detected: $code');
    _stopCamera();
    _openLink(code);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _stopCamera() {
    _scanTimer?.cancel();
    _stream?.getTracks().forEach((track) => track.stop());
    _videoElement?.srcObject = null;
  }

  Future<void> _openLink(String url) async {
    try {
      final Uri incoming = Uri.parse(url);
      String? spotifyAppUri;
      Uri webUri = incoming;

      if (incoming.scheme == 'spotify') {
        spotifyAppUri = url;
      } else if ((incoming.host == 'open.spotify.com' || 
                  incoming.host.endsWith('spotify.com')) && 
                 incoming.pathSegments.isNotEmpty) {
        final seg0 = incoming.pathSegments[0];
        if (seg0 == 'track' && incoming.pathSegments.length >= 2) {
          final id = incoming.pathSegments[1];
          spotifyAppUri = 'spotify:track:$id';
        } else if (seg0 == 'album' && incoming.pathSegments.length >= 2) {
          final id = incoming.pathSegments[1];
          spotifyAppUri = 'spotify:album:$id';
        } else if (seg0 == 'artist' && incoming.pathSegments.length >= 2) {
          final id = incoming.pathSegments[1];
          spotifyAppUri = 'spotify:artist:$id';
        }
      } else {
        spotifyAppUri = null;
      }

      if (spotifyAppUri != null) {
        final Uri appUri = Uri.parse(spotifyAppUri);
        if (await canLaunchUrl(appUri)) {
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }

      debugPrint('Could not launch $url');
    } catch (e) {
      debugPrint('Invalid URL scanned: $url — $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR code on the card',
          style: TextStyle(
            fontFamily: 'SwankyAndMooMooCyrillic',
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2B5FC7),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : !_isInitialized
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Initializing camera...'),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Camera view
                    HtmlElementView(viewType: _viewId),
                    // Overlay with scan frame
                    Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF2B5FC7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Show which detection method is being used
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _useBarcodeDetector 
                                ? 'Using Native API' 
                                : 'Using jsQR (iOS Compatible)',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}