import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/search_books/domain/entities/google_books_volume.dart';
import 'package:flutter/material.dart';

class ModifyBookStateModel extends ChangeNotifier {
  final Book _book;

  final UseCase _addOrEditBookUseCase;
  ModifyBookStateModel(this._addOrEditBookUseCase, this._book);
  
  Book get book => _book;

  Future<bool> saveToDatabase() async {
    if(validateData()){
      await _addOrEditBookUseCase(_book);
      return true;
    }
    return false;
  }

  void fromGoogleBooksVolume(GoogleBooksVolume volume){
    _book.title = volume.title;
    _book.author = volume.authors;
    _book.pages = volume.pageCount;
    _book.thumbnail = volume.thumbnail;
    print(_book);
    notifyListeners();
  }

  String getTitle() => _book.title;
  String getAuthor() => _book.author;
  int getNumberOfPages() => _book.pages;

  void setTitle(String title) {
    _book.title = title;
  }

  void setAuthor(String author) {
    _book.author = author;
  }

  void setNumberOfPages(int pages) {
    _book.pages = pages;
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

  bool validateData(){
    if(book.status == BookStatus.finished && (book.startDate == null || book.finishDate == null)){
      return false;
    }
    if(book.status == BookStatus.reading && book.startDate == null){
      return false;
    }
    return book.title.isNotEmpty && book.author.isNotEmpty && book.pages > 0;
  }
}