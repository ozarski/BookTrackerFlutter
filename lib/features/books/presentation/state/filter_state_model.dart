import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterStateModel extends ChangeNotifier {
  BookStatus status = BookStatus.reading;
  DateTime? startDate; 
  DateTime?  finishDate;

  FilterStateModel();

  String getFormattedStartDate() {
    var startDateString = "";
    if(status == BookStatus.reading) {
      startDateString =  startDate!=null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'started before date';
    } else if(status == BookStatus.finished) {
      startDateString =  startDate!=null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'finished before date';
    }
    else{
      startDateString =  'start date';
    }
    return startDateString;
  }

  String getFormattedFinishDate() {
    var finishDateString = "";
    if(status == BookStatus.reading) {
      finishDateString =  finishDate!=null ? DateFormat('dd/MM/yyyy').format(finishDate!) : 'started after date';
    } else if(status == BookStatus.finished) {
      finishDateString =  finishDate!=null ? DateFormat('dd/MM/yyyy').format(finishDate!) : 'finished after date';
    }
    else{
      finishDateString =  'finish date';
    }
    return finishDateString;
  }

  void setStartDate(DateTime? date) {
    startDate = date;
    notifyListeners();
  }

  void setFinishDate(DateTime? date) {
    finishDate = date;
    notifyListeners();
  }

  void setStatus(BookStatus status) {
    this.status = status;
    notifyListeners();
  }
}


class FilterBookListParams {
  final BookStatus status;
  final DateTime? startDate;
  final DateTime? finishDate;

  FilterBookListParams({
    required this.status,
    required this.startDate,
    required this.finishDate,
  });

  factory FilterBookListParams.fromFilterStateModel(FilterStateModel filterStateModel) {
    return FilterBookListParams(
      status: filterStateModel.status,
      startDate: filterStateModel.startDate,
      finishDate: filterStateModel.finishDate,
    );
  }
}