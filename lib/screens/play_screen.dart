import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // For native (mobile) scanning
  late final MobileScannerController _scannerController;

  // For web scanning
  html.VideoElement? _video;
  html.MediaStream? _stream;
  dynamic _barcodeDetector;
  Timer? _scanTimer;

  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _setupWebScanner();
    } else {
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
      );
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _scanTimer?.cancel();
      _video?.pause();
      _stream?.getTracks().forEach((t) => t.stop());
    } else {
      _scannerController.dispose();
    }
    super.dispose();
  }

  Future<void> _setupWebScanner() async {
    try {
      final supported =
          js_util.getProperty(html.window, "BarcodeDetector") != null;

      if (!supported) {
        debugPrint("BarcodeDetector API not supported by browser.");
        return;
      }

      // Create video
      _video = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..setAttribute('playsinline', 'true');

      // Request camera
      _stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': {'facingMode': 'environment'}
      });

      _video!.srcObject = _stream;
      await _video!.play();

      // Create BarcodeDetector
      _barcodeDetector = js_util.callConstructor(
        js_util.getProperty(html.window, "BarcodeDetector"),
        [
          {'formats': ['qr_code']}
        ],
      );

      // Scan frames
      _scanTimer =
          Timer.periodic(const Duration(milliseconds: 120), (_) => _scanFrame());

      setState(() {});
    } catch (e) {
      debugPrint("Web scanner error: $e");
    }
  }

  // --------------------------
  // WEB QR SCANNING
  // --------------------------
  Future<void> _scanFrame() async {
    if (_hasScanned || _video == null) return;

    try {
      final barcodes = await js_util.promiseToFuture(
        js_util.callMethod(_barcodeDetector, "detect", [_video]),
      );

      if (barcodes is List && barcodes.isNotEmpty) {
        final raw = js_util.getProperty(barcodes.first, "rawValue");

        if (raw is String && raw.isNotEmpty) {
          _hasScanned = true;
          debugPrint("WEB QR detected: $raw");
          _openLink(raw);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint("BarcodeDetector error: $e");
    }
  }

  // --------------------------
  // YOUR EXISTING URL HANDLER
  // --------------------------
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
        if (seg0 == 'track') {
          spotifyAppUri = 'spotify:track:${incoming.pathSegments[1]}';
        } else if (seg0 == 'album') {
          spotifyAppUri = 'spotify:album:${incoming.pathSegments[1]}';
        } else if (seg0 == 'artist') {
          spotifyAppUri = 'spotify:artist:${incoming.pathSegments[1]}';
        }
      }

      if (spotifyAppUri != null) {
        final appUri = Uri.parse(spotifyAppUri);
        if (await canLaunchUrl(appUri)) {
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Invalid URL: $e");
    }
  }

  // --------------------------
  // BUILD UI
  // --------------------------
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
      body: Stack(
        children: [
          if (kIsWeb) ...[
            HtmlElementView(viewType: 'web-scanner-video')
          ] else ...[
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                if (_hasScanned) return;

                final code =
                    capture.barcodes.first.rawValue ?? "";

                if (code.isNotEmpty) {
                  _hasScanned = true;
                  debugPrint("APP QR detected: $code");
                  _openLink(code);
                  Navigator.pop(context);
                }
              },
            ),
          ],
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFF2B5FC7), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
