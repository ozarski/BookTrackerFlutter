
import 'package:book_tracker/widgets/main_tab_bar.dart';
import 'package:book_tracker/widgets/main_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          child: Container(
            color: Colors.white,
            child: const Column(
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
