import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const TabBar(
          tabs: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Tab(icon: Icon(Icons.book_outlined))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Tab(icon: Icon(Icons.bar_chart_outlined))),
          ],
          indicatorColor: Colors.blueGrey,
          labelColor: Colors.blueGrey,
          indicatorPadding: EdgeInsets.only(bottom: 3)),
    );
  }
}
