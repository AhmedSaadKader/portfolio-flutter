import 'package:flutter/material.dart';

import 'package:portfolio_flutter/home.dart';
import 'package:portfolio_flutter/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creative Portfolio',
      // Use FlexColorScheme themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Explicitly use dark theme
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
