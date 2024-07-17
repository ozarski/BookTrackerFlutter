import 'package:book_tracker/main_tab_bar.dart';
import 'package:book_tracker/main_tab_bar_view.dart';
import 'package:flutter/material.dart';

import 'add_book_screen/add_book_screen.dart';

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
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            child: Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_book');
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: MainTabBarView(),
                ),
                MainTabBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
