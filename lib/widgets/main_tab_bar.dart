import 'package:book_tracker/utils/PaddingExtension.dart';
import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
          tabs: [
            const Tab(icon: Icon(Icons.book_outlined))
                .addPadding(const EdgeInsets.symmetric(horizontal: 10)),
            const Tab(icon: Icon(Icons.bar_chart_outlined))
                .addPadding(const EdgeInsets.symmetric(horizontal: 10)),
          ],
          indicatorColor: Colors.blueGrey,
          labelColor: Colors.blueGrey,
          indicatorPadding: const EdgeInsets.only(bottom: 3)),
    );
  }
}
