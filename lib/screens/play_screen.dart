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
  html.MediaStream? _stream;
  Timer? _scanTimer;
  bool _hasScanned = false;
  bool _isInitialized = false;
  String? _error;
  final String _viewId = 'camera-view-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _stopCamera();
    _scanTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      // Check if BarcodeDetector is supported
      final barcodeDetectorSupported = js_util.hasProperty(html.window, 'BarcodeDetector');
      if (!barcodeDetectorSupported) {
        setState(() {
          _error = 'BarcodeDetector not supported in this browser';
        });
        return;
      }

      // Create video element
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..setAttribute('playsinline', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      // Register the view
      ui_web.platformViewRegistry.registerViewFactory(
        _viewId,
        (int viewId) => _videoElement!,
      );

      // Get user media
      final constraints = {
        'video': {
          'facingMode': 'environment', // back camera
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
        }
      };

      _stream = await html.window.navigator.mediaDevices!.getUserMedia(constraints);
      _videoElement!.srcObject = _stream;

      setState(() {
        _isInitialized = true;
      });

      // Start scanning after a short delay to ensure video is playing
      await Future.delayed(const Duration(milliseconds: 500));
      _startScanning();
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize camera: $e';
      });
      debugPrint('Camera initialization error: $e');
    }
  }

  void _startScanning() {
    // Scan every 500ms
    _scanTimer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      if (_hasScanned || _videoElement == null) return;
      await _detectBarcode();
    });
  }

  Future<void> _detectBarcode() async {
    try {
      // Create BarcodeDetector instance
      final barcodeDetector = js_util.callConstructor(
        js_util.getProperty(html.window, 'BarcodeDetector'),
        [js_util.jsify({'formats': ['qr_code']})],
      );

      // Detect barcodes
      final barcodes = await js_util.promiseToFuture(
        js_util.callMethod(barcodeDetector, 'detect', [_videoElement]),
      );

      final barcodeList = js_util.dartify(barcodes) as List;

      if (barcodeList.isNotEmpty && !_hasScanned) {
        final firstBarcode = barcodeList.first as Map;
        final rawValue = firstBarcode['rawValue'] as String?;

        if (rawValue != null && rawValue.isNotEmpty) {
          setState(() {
            _hasScanned = true;
          });
          debugPrint('QR code detected: $rawValue');
          _stopCamera();
          await _openLink(rawValue);
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      debugPrint('Barcode detection error: $e');
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
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : !_isInitialized
              ? const Center(child: CircularProgressIndicator())
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
                  ],
                ),
    );
  }
}