import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/pages/book_list_tab.dart';
import 'package:book_tracker/features/statistics/presentation/pages/stats_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainTabBarView extends StatelessWidget {
  const MainTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (context) => BookListModel(),
      child: const TabBarView(
        children: [
          BookListTab(),
          StatsTab(),
        ],
      ),
    );
  }
}
