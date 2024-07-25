abstract class StatsRepositoryInterface {
  Future<int> getBooksCount();
  Future<int> getTotalPages();
  Future<double> getPagesPerBook();
  Future<double> getPagesPerDay();
  Future<double> getAverageReadingTime();
  Future<double> getBooksPerMonth();
  Future<double> getBooksPerWeek();
}