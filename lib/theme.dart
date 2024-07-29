import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.3)),
    hintStyle: TextStyle(color: Colors.grey),
    labelStyle: TextStyle(color: Colors.grey),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      side: BorderSide(color: Colors.black, width: 0.3),
    ),
    elevation: 4,
  ),
  scaffoldBackgroundColor: const Color(0xFF1F1E22),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFCE76C),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFFFCE76C),
    secondary: const Color(0xFF1F1E22),
    tertiary: const Color.fromARGB(111, 133, 130, 146),
    surface: const Color.fromARGB(130, 252, 230, 108)
  ),
  unselectedWidgetColor: Colors.white,
);
