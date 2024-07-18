import 'package:book_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'screens/add_book_screen.dart';

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
      },
      home: const DefaultTabController(
        length: 2,
        child: HomeScreen(),
      ),
    );
  }
}
