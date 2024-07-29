import 'dart:math';

import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/usecases/display_book_list.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  final DisplayBookListUseCase _displayBookListUseCase;
  final List<Book> _books = [];

  List<Book> get books => _books;

  BookListModel(this._displayBookListUseCase){
    _loadBooks();
  }

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void removeBook(Book book) {
    _books.remove(book);
    notifyListeners();
  }

  void updateBook(Book book) {
    int index = _books.indexWhere((element) => element.id == book.id);
    _books[index] = book;
    notifyListeners();
  }

  void reloadBooks() {
    _loadBooks();
    notifyListeners();
  }

  void _loadBooks() async {
    await _displayBookListUseCase().then((value) {
      _books.clear();
      _books.addAll(value);
      notifyListeners();
    });
  }

  void mockBooks() {
    List<String> bookTitles = [
      'The Great Gatsby',
      'To Kill a Mockingbird',
      '1984',
      'Pride and Prejudice',
      'The Catcher in the Rye',
      'The Lord of the Rings',
      'Animal Farm',
      'Brave New World',
      'The Hobbit',
      'Fahrenheit 451',
      'The Final Empire',
      'The Well of Ascension',
      'The Hero of Ages',
      'The Story of Philosophy',
      'The Art of War',
      'Harry Potter and the Philosopher\'s Stone',
      'Harry Potter and the Chamber of Secrets',
      'Harry Potter and the Prisoner of Azkaban',
      'Harry Potter and the Goblet of Fire',
      'Harry Potter and the Order of the Phoenix',
      'Harry Potter and the Half-Blood Prince',
      'Harry Potter and the Deathly Hallows',
    ];
    List<String> authors = [
      'John Ronald Reuel Tolkien',
      'Brandon Sanderson',
      'J.K. Rowling',
      'Ernest Hemingway',
      'Aldous Huxley',
      'George Orwell',
    ];
    _books.clear();
    _books.addAll(
      List.generate(
        50,
        (index) {
          BookStatus randomBookStatus =
              BookStatus.values[Random().nextInt(BookStatus.values.length)];
          String bookTitle = bookTitles[Random().nextInt(bookTitles.length)];
          String author = authors[Random().nextInt(authors.length)];
          int pages = Random().nextInt(500) + 100;
          DateTime startDate = DateTime.now().subtract(Duration(days: Random().nextInt(365)));
          DateTime finishDate = startDate.add(Duration(days: Random().nextInt(50)));
          int progress = randomBookStatus == BookStatus.reading ? Random().nextInt(pages) : 0;
          return Book(
            title: bookTitle,
            author: author,
            pages: pages,
            status: randomBookStatus,
            progress: progress,
            startDate: startDate,
            finishDate: finishDate
          );
        },
      ),
    );
  }
}
