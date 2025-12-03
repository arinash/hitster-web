import 'package:flutter/material.dart';
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
        ..setAttribute('playsinline', 'true')
        ..setAttribute('webkit-playsinline', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

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
      final barcodeDetectorSupported = js_util.hasProperty(html.window, 'BarcodeDetector');
      _useBarcodeDetector = barcodeDetectorSupported;
      
      debugPrint('BarcodeDetector supported: $_useBarcodeDetector');

      if (_videoElement == null) {
        setState(() {
          _error = 'Video element not initialized';
        });
        return;
      }

      final constraints = {
        'video': {
          'facingMode': {'ideal': 'environment'},
          'width': {'ideal': 1280, 'max': 1920},
          'height': {'ideal': 720, 'max': 1080},
        },
        'audio': false,
      };

      try {
        _stream = await html.window.navigator.mediaDevices!.getUserMedia(constraints);
      } catch (e) {
        debugPrint('Back camera not available, trying any camera: $e');
        final fallbackConstraints = {
          'video': true,
          'audio': false,
        };
        _stream = await html.window.navigator.mediaDevices!.getUserMedia(fallbackConstraints);
      }

      _videoElement!.srcObject = _stream;
      
      await _videoElement!.onLoadedMetadata.first;
      await _videoElement!.play();

      setState(() {
        _isInitialized = true;
      });

      debugPrint('Camera initialized, video dimensions: ${_videoElement!.videoWidth}x${_videoElement!.videoHeight}');

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
      if (!js_util.hasProperty(html.window, 'jsQR')) {
        return;
      }

      final video = _videoElement!;
      
      if (video.readyState != html.MediaElement.HAVE_ENOUGH_DATA) {
        return;
      }

      final canvas = _canvasElement!;
      final width = video.videoWidth;
      final height = video.videoHeight;

      if (width == 0 || height == 0) return;

      canvas.width = width;
      canvas.height = height;

      final context = canvas.getContext('2d') as html.CanvasRenderingContext2D;
      context.drawImageScaled(video, 0, 0, width, height);

      final imageData = context.getImageData(0, 0, width, height);

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
    
    // Close the screen after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _stopCamera() {
    _scanTimer?.cancel();
    _stream?.getTracks().forEach((track) => track.stop());
    _videoElement?.srcObject = null;
  }

  void _openLink(String url) {
    try {
      debugPrint('Opening URL: $url');
      
      final Uri incoming = Uri.parse(url);
      String targetUrl = url;

      // Convert Spotify web URLs to app URLs
      if ((incoming.host == 'open.spotify.com' || 
           incoming.host.endsWith('spotify.com')) && 
          incoming.pathSegments.isNotEmpty) {
        final seg0 = incoming.pathSegments[0];
        if (seg0 == 'track' && incoming.pathSegments.length >= 2) {
          final id = incoming.pathSegments[1];
          targetUrl = 'spotify:track:$id';
        } else if (seg0 == 'album' && incoming.pathSegments.length >= 2) {
          final id = incoming.pathSegments[1];
          targetUrl = 'spotify:album:$id';
        } else if (seg0 == 'artist' && incoming.pathSegments.length >= 2) {
          final id = incoming.pathSegments[1];
          targetUrl = 'spotify:artist:$id';
        } else if (seg0 == 'playlist' && incoming.pathSegments.length >= 2) {
          final id = incoming.pathSegments[1];
          targetUrl = 'spotify:playlist:$id';
        }
      }

      debugPrint('Target URL: $targetUrl');

      // Use direct window.open for better iOS compatibility
      // The '_blank' target with noopener/noreferrer works better on iOS Safari
      html.window.open(targetUrl, '_blank', 'noopener,noreferrer');
      
      debugPrint('Link opened successfully');
    } catch (e) {
      debugPrint('Error opening link: $e');
      
      // Fallback: try opening the original URL
      try {
        html.window.open(url, '_blank', 'noopener,noreferrer');
      } catch (fallbackError) {
        debugPrint('Fallback also failed: $fallbackError');
      }
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
                    HtmlElementView(viewType: _viewId),
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