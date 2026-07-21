import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterStateModel extends ChangeNotifier {
  BookStatus? status;
  DateTime? startDate;
  DateTime? finishDate;

  FilterStateModel();

  String getFormattedStartDate() {
    if (status == null) return 'start date';
    switch (status!) {
      case BookStatus.reading:
        return startDate != null
            ? DateFormat('dd/MM/yyyy').format(startDate!)
            : 'started after date';
      case BookStatus.finished:
        return startDate != null
            ? DateFormat('dd/MM/yyyy').format(startDate!)
            : 'finished after date';
      case BookStatus.wantToRead:
        return 'start date';
    }
  }

  String getFormattedFinishDate() {
    if (status == null) return 'finish date';
    switch (status!) {
      case BookStatus.reading:
        return finishDate != null
            ? DateFormat('dd/MM/yyyy').format(finishDate!)
            : 'started before date';
      case BookStatus.finished:
        return finishDate != null
            ? DateFormat('dd/MM/yyyy').format(finishDate!)
            : 'finished before date';
      case BookStatus.wantToRead:
        return 'finish date';
    }
  }

  void setStartDate(DateTime? date) {
    startDate = date;
    notifyListeners();
  }

  void setFinishDate(DateTime? date) {
    finishDate = date;
    notifyListeners();
  }

  void setStatus(BookStatus? newStatus) {
    status = newStatus;
    notifyListeners();
  }

  void reset() {
    status = null;
    startDate = null;
    finishDate = null;
    notifyListeners();
  }
}

class FilterBookListParams {
  final BookStatus? status;
  final DateTime? startDate;
  final DateTime? finishDate;

  FilterBookListParams({
    this.status,
    this.startDate,
    this.finishDate,
  });

  factory FilterBookListParams.fromFilterStateModel(
      FilterStateModel filterStateModel) {
    return FilterBookListParams(
      status: filterStateModel.status,
      startDate: filterStateModel.startDate,
      finishDate: filterStateModel.finishDate,
    );
  }
}
