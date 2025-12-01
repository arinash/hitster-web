import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

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
      body: AiBarcodeScanner(
        onDetect: (BarcodeCapture capture) {
          if (_hasScanned) return;
          
          final barcode = capture.barcodes.firstOrNull;
          if (barcode == null || barcode.rawValue == null) return;
          
          setState(() {
            _hasScanned = true;
          });

          final String code = barcode.rawValue!;
          debugPrint('QR code detected: $code');
          _openLink(code);
          
          Navigator.pop(context);
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        overlayBuilder: (context, constraints) {
          return Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2B5FC7), width: 2),
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          );
        },
      ),
    );
  }
}