import 'package:book_tracker/utils/PaddingExtension.dart';
import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 0.5),
        ),
        color: Colors.white,
      ),
      child: TabBar(
        tabs: [
          const Tab(
              icon: Icon(
            Icons.book_outlined,
            weight: 6,
          )).addPadding(const EdgeInsets.symmetric(horizontal: 10)),
          const Tab(icon: Icon(Icons.bar_chart_outlined))
              .addPadding(const EdgeInsets.symmetric(horizontal: 10)),
        ],
        indicatorColor: Colors.black,
        labelColor: Colors.black,
        indicatorPadding: const EdgeInsets.only(bottom: 3),
        unselectedLabelColor: Colors.grey,
      ),
    );
  }
}
