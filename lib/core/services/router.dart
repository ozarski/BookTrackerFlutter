import 'package:book_tracker/core/pages/home_screen.dart';
import 'package:book_tracker/features/books/presentation/pages/add_book_screen.dart';
import 'package:book_tracker/features/books/presentation/pages/book_details_screen.dart';
import 'package:book_tracker/features/books/presentation/pages/edit_book_screen.dart';
import 'package:book_tracker/features/search_books/presentation/screens/book_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RouteGenerator {
  static const String home = '/';
  static const String addBook = '/add_book';
  static const String bookDetails = '/book_details';
  static const String editBook = '/edit_book';
  static const String search = '/search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/add_book':
        return _fadePageBuilder((context) => const AddBookScreen(),
            settings: settings);
      case '/book_details':
        return _fadePageBuilder((context) => const BookDetailsScreen(),
            settings: settings);
      case '/edit_book':
        return _fadePageBuilder((context) => const EditBookScreen(),
            settings: settings);
      case '/search':
        return _fadePageBuilder((context) => const BookSearchScreen(),
            settings: settings);
      default:
        return _fadePageBuilder((context) => const HomeScreen(),
            settings: settings);
    }
  }

  static PageRouteBuilder<dynamic> _fadePageBuilder(
      Widget Function(BuildContext) page,
      {required RouteSettings settings}) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (context, _, __) => page(context),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
