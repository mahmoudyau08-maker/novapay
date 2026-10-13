import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Solid, high-contrast banner. Unlike the tiled watermark, this is meant to
/// be impossible to miss even in a quick glance or a cropped screenshot.
class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.red.shade700,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Text(
        AppConstants.watermarkText,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
