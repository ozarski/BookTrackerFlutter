import 'package:book_tracker/features/statistics/domain/usecases/get_books_for_each_month.dart';
import 'package:book_tracker/features/statistics/domain/usecases/get_stats.dart';
import 'package:flutter/material.dart';

class StatsStateModel extends ChangeNotifier {
  final GetStatsUseCase _getStatsUseCase;
  final GetBooksForEachMonthUseCase _getBooksForEachMonthUseCase;

  StatsStateModel(this._getStatsUseCase, this._getBooksForEachMonthUseCase) {
    _loadStats();
  }

  Map<String, String> _stats = {};

  Map<String, String> get stats => _stats;

  Map<int, int> _booksPerMonth = {};

  Map<int, int> get booksPerMonth => _booksPerMonth;

  void _loadStats() async {
    await _getStatsUseCase().then((value) {
      _stats = value;
      notifyListeners();
    });

    await _getBooksForEachMonthUseCase(DateTime.now().year).then((value) {
      _booksPerMonth = value;
      notifyListeners();
    });
  }

  void reloadStats() {
    _loadStats();
  }
}