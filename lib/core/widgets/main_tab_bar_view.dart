import 'package:book_tracker/features/books/presentation/pages/book_list_tab.dart';
import 'package:book_tracker/features/statistics/presentation/pages/stats_tab.dart';
import 'package:flutter/material.dart';

class MainTabBarView extends StatelessWidget {
  const MainTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        BookListTab(),
        StatsTab(),
      ],
    );
  }
}
