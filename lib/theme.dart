import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  // Define your color schemes
  static final lightTheme = FlexThemeData.light(
    scheme: FlexScheme.deepBlue,
  );

  static final darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.deepBlue,
  );

  // Custom text themes can still be added if needed
  // static TextTheme get _customTextTheme => TextTheme(
  //       displayLarge: TextStyle(
  //         color: Colors.white,
  //         fontSize: 56,
  //         fontWeight: FontWeight.bold,
  //         letterSpacing: -1,
  //       ),
  //       displayMedium: TextStyle(
  //         color: const Color(0xFF6C63FF),
  //         fontSize: 24,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       bodyLarge: TextStyle(
  //         color: const Color(0xFFE0E0E0),
  //         fontSize: 16,
  //       ),
  //     );
}
