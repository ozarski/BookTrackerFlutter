import 'package:book_tracker/features/books/domain/entities/book.dart';

abstract class ReadingTimeRepositoryInterface {
  Future<void> addReadingTimeForBook(Book book);
  Future<int> getReadingTimeForBook(int bookId);
  Future<void> deleteReadingTimeForBook(int bookId);
  Future<int> getReadingTimeForTimePeriod(DateTime startDate, DateTime endDate);
  Future<int> getTotalReadingTime();
}