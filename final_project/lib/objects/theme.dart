import 'package:flutter/material.dart';

ThemeData lakeNixonTheme() {
  return ThemeData(
      // Define the default brightness and colors.
      colorScheme: lakeNixonColorScheme(),

      // Define the default font family.
      fontFamily: 'Fruit',

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: lakeNixonTextTheme());
}

ColorScheme lakeNixonColorScheme() {
  Color nixonBlue = const Color.fromRGBO(165, 223, 249, 1);
  Color nixonYellow = const Color.fromRGBO(255, 248, 153, 1);
  Color nixonBrown = const Color.fromRGBO(137, 116, 73, 1);
  Color nixonGreen = const Color.fromRGBO(81, 146, 78, 1);

  return ColorScheme(
      brightness: Brightness.light,
      primary: nixonBlue,
      onPrimary: nixonBrown,
      secondary: nixonGreen,
      onSecondary: const Color(0xffffffff),
      tertiary: nixonBrown,
      onTertiary: const Color(0xffffffff),
      error: const Color(0xffe47373),
      onError: const Color(0xffffffff),
      background: const Color(0xffffffff),
      onBackground: nixonBrown,
      surface: const Color(0xffffffff),
      onSurface: nixonBrown,
      surfaceVariant: nixonYellow,
      onSurfaceVariant: nixonBrown,
      outline: nixonBrown);
}

TextTheme lakeNixonTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
    titleMedium:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w300, wordSpacing: 0.15),
    titleSmall:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w300, wordSpacing: 0.1),
    bodyLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w400, wordSpacing: 0.15),
    bodyMedium:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, wordSpacing: 0.25),
    bodySmall:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, wordSpacing: 0.4),
    labelLarge:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w300, wordSpacing: 0.1),
    labelMedium:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w300, wordSpacing: 0.5),
    labelSmall:
        TextStyle(fontSize: 11, fontWeight: FontWeight.w300, wordSpacing: 0.5),
  );
}
