import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
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