import 'package:flutter/material.dart';

ThemeData lakeNixonTheme() {
  return ThemeData(
      // Define the default brightness and colors.
      colorScheme: lakeNixonColorScheme(),

      // Define the default font family.
      fontFamily: 'Itim',

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
        fontFamily: 'Itim',
        fontSize: 26,
        fontWeight: FontWeight.w900,
        wordSpacing: 0.15,
        color: Color.fromRGBO(81, 146, 78, 1)),
    bodyMedium: TextStyle(
        fontFamily: 'Work Sans',
        fontSize: 18,
        fontWeight: FontWeight.w900,
        wordSpacing: 0.25,
        color: Color.fromRGBO(137, 116, 73, 1)),
    bodySmall: TextStyle(
        fontFamily: 'Work Sans',
        fontSize: 12,
        fontWeight: FontWeight.w900,
        wordSpacing: 0.4,
        color: Color.fromRGBO(137, 116, 73, 1)),
    titleLarge: TextStyle(
        fontFamily: 'Itim',
        fontSize: 24,
        fontWeight: FontWeight.w900,
        wordSpacing: 0.4,
        color: Colors.white),
    titleMedium: TextStyle(
        fontFamily: 'Itim',
        fontSize: 20,
        fontWeight: FontWeight.w900,
        wordSpacing: 0.4,
        color: Colors.white),
    displaySmall: TextStyle(
        fontFamily: 'Itim',
        fontSize: 42,
        fontWeight: FontWeight.w900,
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
      fontFamily: 'Itim',
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: Colors.white);
  TextStyle get appBarFilter => const TextStyle(
      fontFamily: 'Itim',
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: Colors.white);
  TextStyle get smallButton => const TextStyle(
      fontFamily: 'Itim',
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: Colors.white);
  TextStyle get mediumButton => const TextStyle(
      fontFamily: 'Itim',
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: Color.fromRGBO(81, 146, 78, 1));
  TextStyle get largeButton => const TextStyle(
      fontFamily: 'Itim',
      fontSize: 42,
      fontWeight: FontWeight.w900,
      color: Colors.white);
  TextStyle get pageHeader => const TextStyle(
      fontFamily: 'Itim',
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: Color.fromRGBO(137, 116, 73, 1));
}
