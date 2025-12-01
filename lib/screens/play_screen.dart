import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Import both packages normally
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool _hasScanned = false;

  Future<void> _openLink(String url) async {
    try {
      final Uri incoming = Uri.parse(url);

      String? spotifyAppUri;
      Uri webUri = incoming;

      if (incoming.scheme == 'spotify') {
        spotifyAppUri = url;
      } else if ((incoming.host == 'open.spotify.com' || incoming.host.endsWith('spotify.com')) && incoming.pathSegments.isNotEmpty) {
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

  void _handleScan(String code) {
    if (_hasScanned) return;
    
    setState(() {
      _hasScanned = true;
    });

    debugPrint('QR code detected: $code');
    _openLink(code);
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR code on the card', style: TextStyle(
          fontFamily: 'SwankyAndMooMooCyrillic',
          color: Colors.white
        ),),
        backgroundColor: Color(0xFF2B5FC7),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: kIsWeb 
          ? _WebScanner(onScan: _handleScan, hasScanned: _hasScanned)
          : _MobileScanner(onScan: _handleScan, hasScanned: _hasScanned),
    );
  }
}

class _MobileScanner extends StatefulWidget {
  final Function(String) onScan;
  final bool hasScanned;

  const _MobileScanner({required this.onScan, required this.hasScanned});

  @override
  State<_MobileScanner> createState() => _MobileScannerState();
}

class _MobileScannerState extends State<_MobileScanner> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: (barcodeCapture) {
            final String? code = barcodeCapture.barcodes.first.rawValue;
            if (code != null && !widget.hasScanned) {
              _controller.stop();
              widget.onScan(code);
            }
          },
        ),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2B5FC7), width: 2),
              borderRadius: BorderRadius.circular(10)
            ),
          ),
        )
      ],
    );
  }
}

class _WebScanner extends StatelessWidget {
  final Function(String) onScan;
  final bool hasScanned;

  const _WebScanner({required this.onScan, required this.hasScanned});

  @override
  Widget build(BuildContext context) {
    return QRCodeDartScanView(
      scanInvertedQRCode: true,
      onCapture: (Result result) {
        if (!hasScanned) {
          onScan(result.text);
        }
      },
    );
  }
}