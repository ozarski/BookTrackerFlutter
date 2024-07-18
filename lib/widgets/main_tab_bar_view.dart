import 'package:book_tracker/widgets/book_list_tab.dart';
import 'package:flutter/material.dart';

class MainTabBarView extends StatelessWidget {
  const MainTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(children: [
      BookListTab(),
      Icon(Icons.bar_chart_outlined, size: 100)
    ]);
  }
}
