import 'package:flutter/material.dart';

/// Full-width button with optional icon and loading spinner.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        else if (icon != null)
          Icon(icon, size: 22),
        if (loading || icon != null) const SizedBox(width: 10),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );

    final handler = loading ? null : onPressed;

    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(onPressed: handler, child: content)
          : FilledButton(onPressed: handler, child: content),
    );
  }
}
