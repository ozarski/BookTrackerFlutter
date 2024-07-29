import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/statistics/data/repositories/stats_repository.dart';

class GetStatsUseCase implements UseCaseNoParams<Map<String, String>>{

  final StatsRepository statsRepository;

  GetStatsUseCase(this.statsRepository);

  @override
  Future<Map<String, String>> call() async {
    var stats = <String, String>{
      'total pages': (await statsRepository.getTotalPages()).toString(),
      'total books': (await statsRepository.getBooksCount()).toString(),
      'pages per day': (await statsRepository.getPagesPerDay()).toStringAsFixed(0),
      'books per month': (await statsRepository.getBooksPerMonth()).toStringAsFixed(1),
      'pages per book': (await statsRepository.getPagesPerBook()).toStringAsFixed(0),
      'days per book': (await statsRepository.getAverageReadingTime()).toStringAsFixed(1),
      'books per week': (await statsRepository.getBooksPerWeek()).toStringAsFixed(1),
      'books per year': (await statsRepository.getBooksPerYear()).toStringAsFixed(1),
    };

    return stats;
  }

}