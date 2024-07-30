abstract class StatsRepositoryInterface {
  Future<int> getBooksCount();
  Future<int> getTotalPages();
  Future<double> getPagesPerBook();
  Future<double> getPagesPerDay();
  Future<double> getAverageReadingTime();
  Future<double> getBooksPerMonth();
  Future<double> getBooksPerWeek();
  Future<double> getBooksPerYear();
  Future<int> booksToBeReadThisYear([DateTime date]);
  Future<int> booksReadInYear(int year);
  Future<int> booksReadInMonth(int month, int year);
}