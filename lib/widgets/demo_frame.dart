import 'package:flutter/material.dart';

import 'demo_banner.dart';
import 'watermark_overlay.dart';

/// Wraps a screen's content with the tiled watermark and a solid banner top
/// and bottom. Used on every screen, and specifically wrapped in a
/// RepaintBoundary wherever content gets exported or shared, so the
/// watermark is part of whatever image comes out.
class DemoFrame extends StatelessWidget {
  const DemoFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DemoWatermark(
      child: Column(
        children: [
          const DemoBanner(),
          Expanded(child: child),
          const DemoBanner(),
        ],
      ),
    );
  }
}
