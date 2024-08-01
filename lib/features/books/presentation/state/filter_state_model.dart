import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:flutter/material.dart';

class FilterStateModel extends ChangeNotifier {
  BookStatus status = BookStatus.reading;
  DateTime? startDate; 
  DateTime?  finishDate;
  final BookListModel _bookListModel;

  FilterStateModel(this._bookListModel);

  void setFiltering(bool value) {
    _bookListModel.filterList(this);
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