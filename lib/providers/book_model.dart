import 'package:book_tracker/models/book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookModel extends ChangeNotifier{

  Book book;

  BookModel({required this.book});

  String getStartDate(){
    return book.startDate != null ? DateFormat('dd.MM.yyyy').format(book.startDate!) : '';
  }

  String getFinishDate(){
    return book.finishDate != null ? DateFormat('dd.MM.yyyy').format(book.finishDate!) : '';
  } 

  void updateProgress(int progress){
    book.progress = progress;
    notifyListeners();
  }

  void setStatus(BookStatus status) {
    if(status == BookStatus.finished && book.finishDate == null) {
      book.finishDate = DateTime.now();
    } else if(status == BookStatus.reading && book.startDate == null) {
      book.startDate = DateTime.now();
    } 
    book.status = status;
    notifyListeners();
  }

}