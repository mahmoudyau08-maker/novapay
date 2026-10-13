import 'package:flutter/material.dart';

import 'screens/disclaimer_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'utils/constants.dart';

void main() {
  runApp(const NovaPayApp());
}

class NovaPayApp extends StatelessWidget {
  const NovaPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeController.mode,
          home: const DisclaimerScreen(),
        );
      },
    );
  }
}
