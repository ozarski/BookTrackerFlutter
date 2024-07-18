import 'dart:math';

import 'package:book_tracker/models/book.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get books => _books;

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void removeBook(Book book) {
    _books.remove(book);
    notifyListeners();
  }

  void mockBooks() {
    _books.clear();
    _books.addAll(
      List.generate(
        50,
        (index) {
          BookStatus randomBookStatus =
              BookStatus.values[Random().nextInt(BookStatus.values.length)];
          return Book(
            title: 'Book no: $index',
            author: 'Author no: $index',
            pages: Random().nextInt(500) + 100,
            status: randomBookStatus,
          );
        },
      ),
    );
  }
}
