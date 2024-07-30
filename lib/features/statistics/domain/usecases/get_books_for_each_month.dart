import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/statistics/data/repositories/stats_repository.dart';

class GetBooksForEachMonthUseCase implements UseCase<Map<int, int>, int> {
  final StatsRepository statsRepository;

  GetBooksForEachMonthUseCase(this.statsRepository);

  @override
  Future<Map<int, int>> call(int year) async {
    return await statsRepository.booksReadEachMonthForYear(year);
  }
}