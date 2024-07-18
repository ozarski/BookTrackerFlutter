import 'package:book_tracker/models/book.dart';
import 'package:flutter/material.dart';

class NewBookModel extends ChangeNotifier {
  final Book _book = Book.addBookInit();

  Book get book => _book;

  void setTitle(String title) {
    _book.title = title;
    notifyListeners();
  }

  void setAuthor(String author) {
    _book.author = author;
    notifyListeners();
  }

  void setNumberOfPages(int pages) {
    _book.pages = pages;
    notifyListeners();
  }

  void setStartDate(DateTime startDate) {
    _book.setStartDate(startDate);
    notifyListeners();
  }

  void setFinishDate(DateTime finishDate) {
    _book.setFinishDate(finishDate);
    notifyListeners();
  }

  void setStatus(BookStatus status) {
    _book.setStatus(status);
    notifyListeners();
  }
}