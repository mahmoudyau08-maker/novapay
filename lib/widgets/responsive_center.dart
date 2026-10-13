import 'package:flutter/material.dart';

/// Page body that scrolls when tall, stays centered and capped in width on
/// larger screens, and fills small phones edge to edge.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 520,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minHeight =
              (constraints.maxHeight - padding.vertical).clamp(0.0, double.infinity);
          return SingleChildScrollView(
            padding: padding,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  minHeight: minHeight.toDouble(),
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
