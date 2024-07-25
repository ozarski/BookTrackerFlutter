import 'package:book_tracker/features/statistics/domain/usecases/get_stats.dart';
import 'package:flutter/material.dart';

class StatsStateModel extends ChangeNotifier {
  final GetStatsUseCase _getStatsUseCase;

  StatsStateModel(this._getStatsUseCase) {
    _loadStats();
  }

  Map<String, String> _stats = {};

  Map<String, String> get stats => _stats;

  void _loadStats() async {
    await _getStatsUseCase().then((value) {
      _stats = value;
      notifyListeners();
    });
  }

  void reloadStats() {
    _loadStats();
  }
}