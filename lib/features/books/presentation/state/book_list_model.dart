import 'dart:math';

import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/usecases/display_book_list.dart';
import 'package:book_tracker/features/books/domain/usecases/filter_book_list.dart';
import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  final DisplayBookListUseCase _displayBookListUseCase;
  final FilterBookListUseCase _filterBookListUseCase;
  final List<Book> _allBooks = [];
  final List<Book> _displayedBooks = [];

  List<Book> get books => _displayedBooks;
  bool searching = false;
  String? _currentSearchQuery;
  FilterBookListParams? _currentFilterParams;

  String? get isEmptyMessage {
    if (_allBooks.isEmpty) return 'No books yet. Tap + to add one.';
    if (_displayedBooks.isEmpty) return 'No books match your search or filter.';
    return null;
  }

  BookListModel(this._displayBookListUseCase, this._filterBookListUseCase) {
    _loadBooks();
  }

  void addBook(Book book) {
    _allBooks.add(book);
    _applyLocalFilters();
  }

  void removeBook(Book book) {
    _allBooks.remove(book);
    _applyLocalFilters();
  }

  void updateBook(Book book) {
    int index = _allBooks.indexWhere((element) => element.id == book.id);
    if (index != -1) {
      _allBooks[index] = book;
    }
    _applyLocalFilters();
  }

  void reloadBooks() {
    _currentSearchQuery = null;
    _currentFilterParams = null;
    searching = false;
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    var books = await _displayBookListUseCase();
    _allBooks.clear();
    _allBooks.addAll(books);
    _applyLocalFilters();
  }

  void filterList(FilterStateModel filterState) async {
    _currentFilterParams =
        FilterBookListParams.fromFilterStateModel(filterState);
    await _applyFilters();
  }

  Future<void> _applyFilters() async {
    if (_currentFilterParams != null) {
      var books = await _filterBookListUseCase(_currentFilterParams!);
      _allBooks.clear();
      _allBooks.addAll(books);
    } else {
      await _loadBooks();
      return;
    }
    _applyLocalFilters();
  }

  void _applyLocalFilters() {
    _displayedBooks.clear();
    if (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty) {
      var q = _currentSearchQuery!.toLowerCase();
      _displayedBooks.addAll(_allBooks.where((b) =>
          b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q)));
    } else {
      _displayedBooks.addAll(_allBooks);
    }
    notifyListeners();
  }

  void searchBooks(String query) {
    if (query.isEmpty) {
      _currentSearchQuery = null;
    } else {
      _currentSearchQuery = query;
    }
    searching = _currentSearchQuery != null;
    _applyLocalFilters();
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
    _allBooks.clear();
    _allBooks.addAll(
      List.generate(
        50,
        (index) {
          BookStatus randomBookStatus =
              BookStatus.values[Random().nextInt(BookStatus.values.length)];
          String bookTitle = bookTitles[Random().nextInt(bookTitles.length)];
          String author = authors[Random().nextInt(authors.length)];
          int pages = Random().nextInt(500) + 100;
          DateTime startDate =
              DateTime.now().subtract(Duration(days: Random().nextInt(365)));
          DateTime finishDate =
              startDate.add(Duration(days: Random().nextInt(50)));
          int progress = randomBookStatus == BookStatus.reading
              ? Random().nextInt(pages)
              : 0;
          return Book(
              title: bookTitle,
              author: author,
              pages: pages,
              status: randomBookStatus,
              progress: progress,
              startDate: startDate,
              finishDate: finishDate);
        },
      ),
    );
    _applyLocalFilters();
  }
}
