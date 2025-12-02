import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {

  late final MobileScannerController _scannerController;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String url) async {

    try {
      final Uri incoming = Uri.parse(url);

      String? spotifyAppUri;
      Uri webUri = incoming;

      if (incoming.scheme == 'spotify') {
        // already an app uri
        spotifyAppUri = url;
      } else if ((incoming.host == 'open.spotify.com' || incoming.host.endsWith('spotify.com')) && incoming.pathSegments.isNotEmpty) {
        // e.g. /track/{id}
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
        // keep webUri as the original https link (incoming)
      } else {
        // If the scanned code is not a spotify link, just try opening it directly
        spotifyAppUri = null;
      }

      // Try to open in Spotify app first (if we have a spotifyAppUri)
      if (spotifyAppUri != null) {
        final Uri appUri = Uri.parse(spotifyAppUri);
        if (await canLaunchUrl(appUri)) {
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      // Fallback to web link
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
          color:  Colors.white
        ),),
        backgroundColor: Color(0xFF2B5FC7),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (barcodeCapture) {
              if (_hasScanned) return;

              // The web implementation of MobileScanner may sometimes
              // send a BarcodeCapture with an empty `barcodes` list.
              // Guard against that to avoid `Bad state: No element`.
              final barcodes = barcodeCapture.barcodes;
              if (barcodes.isEmpty) return;

              // Prefer the first non-null rawValue from detected barcodes.
              String? code;
              for (final b in barcodes) {
                if (b.rawValue != null && b.rawValue!.isNotEmpty) {
                  code = b.rawValue;
                  break;
                }
              }

              if (code != null) {
                setState(() {
                  _hasScanned = true;
                });

                debugPrint('QR code detected: $code');
                _openLink(code);

                // Stop camera and go back once we've handled a code.
                _scannerController.stop();
                Navigator.pop(context);
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
      ),
    );
  }
}