import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: TabBar(
        dividerColor: Theme.of(context).colorScheme.primary,
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
        unselectedLabelColor: const Color.fromARGB(255, 131, 135, 102),
      ),
    );
  }
}
