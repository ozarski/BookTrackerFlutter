import 'package:book_tracker/features/books/presentation/pages/book_details_screen.dart';
import 'package:book_tracker/core/pages/home_screen.dart';
import 'package:flutter/material.dart';

import 'features/books/presentation/pages/add_book_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/add_book': (BuildContext context) => const AddBookScreen(),
        '/book_details': (BuildContext context) => const BookDetailsScreen(),
      },
      theme: ThemeData(
        textTheme:
            const TextTheme(bodyMedium: TextStyle(fontWeight: FontWeight.w300)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.3)),
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
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
      ),
      home: const DefaultTabController(
        length: 2,
        child: HomeScreen(),
      ),
    );
  }
}
