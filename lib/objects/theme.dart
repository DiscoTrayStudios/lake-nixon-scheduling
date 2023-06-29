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
  return const ColorScheme.light(
      primary: Color.fromRGBO(81, 146, 78, 1),
      secondary: Color.fromRGBO(137, 116, 73, 1),
      tertiary: Color.fromRGBO(165, 223, 249, 1));
}

TextTheme lakeNixonTextTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w300,
        wordSpacing: 0.15,
        color: Color.fromRGBO(81, 146, 78, 1)),
    bodyMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        wordSpacing: 0.25,
        color: Color.fromRGBO(137, 116, 73, 1)),
    bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        wordSpacing: 0.4,
        color: Color.fromRGBO(137, 116, 73, 1)),
    titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        wordSpacing: 0.4,
        color: Colors.white),
    titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        wordSpacing: 0.4,
        color: Colors.white),
    displaySmall: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(81, 146, 78, 1)),
  );
}

extension LakeNixonColorScheme on ColorScheme {
  Color get nixonBlue => const Color.fromRGBO(165, 223, 249, 1);
  Color get nixonBrown => const Color.fromRGBO(137, 116, 73, 1);
  Color get nixonGreen => const Color.fromRGBO(81, 146, 78, 1);
}

extension LakeNixonTextTheme on TextTheme {
  TextStyle get appBarTitle => const TextStyle(
      fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white);
  TextStyle get appBarFilter => const TextStyle(
      fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white);
  TextStyle get smallButton => const TextStyle(
      fontSize: 32, fontWeight: FontWeight.w300, color: Colors.white);
  TextStyle get mediumButton => const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(81, 146, 78, 1));
  TextStyle get largeButton => const TextStyle(
      fontSize: 42, fontWeight: FontWeight.w400, color: Colors.white);
  TextStyle get pageHeader => const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(137, 116, 73, 1));
}
