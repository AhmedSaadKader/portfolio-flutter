import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:portfolio_flutter/router.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();

  runApp(ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
      routerConfig: router,
      title: 'Portfolio',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
    );
  }
}
