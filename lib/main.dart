import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/features/books/data/repositories/book_repository.dart';
import 'package:book_tracker/features/books/domain/usecases/add_book.dart';
import 'package:book_tracker/features/books/domain/usecases/delete_book.dart';
import 'package:book_tracker/features/books/domain/usecases/display_book_details.dart';
import 'package:book_tracker/features/books/domain/usecases/display_book_list.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_progress.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_status.dart';
import 'package:book_tracker/features/books/presentation/pages/book_details_screen.dart';
import 'package:book_tracker/core/pages/home_screen.dart';
import 'package:book_tracker/features/books/presentation/pages/edit_book_screen.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/search_books/data/data_sources/google_books_api_service.dart';
import 'package:book_tracker/features/search_books/data/repositories/google_books_repository.dart';
import 'package:book_tracker/features/search_books/domain/usecases/display_volumes.dart';
import 'package:book_tracker/features/search_books/presentation/screens/book_search_screen.dart';
import 'package:book_tracker/features/statistics/data/repositories/stats_repository.dart';
import 'package:book_tracker/features/statistics/domain/usecases/get_stats.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/books/presentation/pages/add_book_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<BookDatabase>(
          create: (_) => BookDatabase.instance,
          dispose: (_, db) async => await db.close(),
        ),
        Provider<Dio>(
          create: (_) => Dio(),
        ),
        ProxyProvider<Dio, GoogleBooksApiService>(
          update: (_, dio, __) => GoogleBooksApiService(dio),
        ),
        ProxyProvider<GoogleBooksApiService, GoogleBooksRepository>(
          update: (_, apiService, __) => GoogleBooksRepository(apiService),
        ),
        ProxyProvider<BookDatabase, BookRepository>(
          update: (_, database, __) => BookRepository(database),
        ),
        ProxyProvider<BookDatabase, StatsRepository>(
          update: (_, database, __) => StatsRepository(database),
        ),
        ProxyProvider<BookRepository, AddBookUseCase>(
          update: (_, repository, __) => AddBookUseCase(repository),
        ),
        ProxyProvider<BookRepository, DisplayBookListUseCase>(
          update: (_, repository, __) => DisplayBookListUseCase(repository),
        ),
        ProxyProvider<BookRepository, DisplayBookDetailsUseCase>(
          update: (_, repository, __) => DisplayBookDetailsUseCase(repository),
        ),
        ProxyProvider<BookRepository, UpdateBookProgressUseCase>(
          update: (_, repository, __) => UpdateBookProgressUseCase(repository),
        ),
        ProxyProvider<BookRepository, UpdateBookStatusUseCase>(
          update: (_, repository, __) => UpdateBookStatusUseCase(repository),
        ),
        ProxyProvider<BookRepository, DeleteBookUseCase>(
          update: (_, repository, __) => DeleteBookUseCase(repository),
        ),
        ProxyProvider<BookRepository, UpdateBookUseCase>(
          update: (_, repository, __) => UpdateBookUseCase(repository),
        ),
        ProxyProvider<StatsRepository, GetStatsUseCase>(
          update: (_, repository, __) => GetStatsUseCase(repository),
        ),
        ProxyProvider<GoogleBooksRepository, DisplayVolumesUseCase>(
          update: (_, repository, __) => DisplayVolumesUseCase(repository),
        ),
        ChangeNotifierProvider<BookListModel>(
          create: (context) => BookListModel(context.read<DisplayBookListUseCase>()),
        ),
        ChangeNotifierProvider<StatsStateModel>(
          create: (context) => StatsStateModel(context.read<GetStatsUseCase>()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/add_book': (BuildContext context) => const AddBookScreen(),
        '/book_details': (BuildContext context) => const BookDetailsScreen(),
        '/edit_book': (BuildContext context) => const EditBookScreen(),
        '/search': (BuildContext context) => const BookSearchScreen(),
      },
      theme: ThemeData(
        textTheme:
            const TextTheme(bodyMedium: TextStyle(fontWeight: FontWeight.w300)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.3)),
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Colors.black, width: 0.3),
          ),
          elevation: 4,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
      ),
      home: const DefaultTabController(
        length: 2,
        child: HomeScreen(),
      ),
     debugShowCheckedModeBanner: false,
    );
  }
}
