import 'package:book_tracker/core/services/router.dart';
import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/core/widgets/main_tab_bar.dart';
import 'package:book_tracker/core/widgets/main_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          splashColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.addBook,
            );
          },
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
        ),
      ).addPadding(const EdgeInsets.only(bottom: 50, right: 20)),
      body: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Theme.of(context).colorScheme.primary,
              statusBarIconBrightness: Brightness.dark),
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
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
