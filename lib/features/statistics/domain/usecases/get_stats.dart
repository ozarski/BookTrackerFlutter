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
      'pages per day': (await statsRepository.getPagesPerDay()).toStringAsFixed(2),
      'books per month': (await statsRepository.getBooksPerMonth()).toStringAsFixed(2),
      'pages per book': (await statsRepository.getPagesPerBook()).toStringAsFixed(2),
      'days per book': (await statsRepository.getAverageReadingTime()).toStringAsFixed(2),
      'books per week': (await statsRepository.getBooksPerWeek()).toStringAsFixed(2),
    };

    return stats;
  }

}