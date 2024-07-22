import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/data/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class NewBookStateModel extends ChangeNotifier {
  final Book _book = Book.addBookInit();

  Book get book => _book;

  void saveToDatabase() async {
    final bookRepository = BookRepository();

    await bookRepository.addBook(_book);
  }

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