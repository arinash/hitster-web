import 'package:flutter/material.dart';

class RuleCard extends StatelessWidget {
  const RuleCard({
    super.key,
    required this.header,
    required this.rule,
    this.iconAsset,
  });

  final String header;
  final String rule;
  final String? iconAsset; // optional asset path to a PNG icon shown on the left

  static const Color _accent = Color(0xFF2B5FC7);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _accent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // First row: icon (if provided) and header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (iconAsset != null) ...[
                  Image.asset(
                    iconAsset!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    header,
                    style: const TextStyle(
                      color: _accent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Second row: rule description text
            Text(
              rule,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}