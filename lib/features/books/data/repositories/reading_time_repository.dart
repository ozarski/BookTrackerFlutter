import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/core/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/repositories/reading_time_repository_interface.dart';
import 'package:sqflite/sqflite.dart';

class ReadingTimeRepository implements ReadingTimeRepositoryInterface {
  final BookDatabase bookDatabase;

  ReadingTimeRepository(this.bookDatabase);

  @override
  Future<void> addReadingTimeForBook(Book book) async {
    final db = await bookDatabase.database;

    final daysToInsert = getReadingDaysForBook(book);

    Batch batch = db.batch();

    for (var day in daysToInsert) {
      batch.insert(BookDatabaseConstants.readingTimeTableName, {
        BookDatabaseConstants.columnDate: day.millisecondsSinceEpoch,
        BookDatabaseConstants.columnBookId: book.id
      });
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> deleteReadingTimeForBook(int bookId) async {
    final db = await bookDatabase.database;

    await db.delete(
      BookDatabaseConstants.readingTimeTableName,
      where: '${BookDatabaseConstants.columnBookId} = ?',
      whereArgs: [bookId],
    );
  }

  @override
  Future<int> getReadingTimeForBook(int bookId) {
    final db = bookDatabase.database;

    return db.then((database) async {
      final result = await database.query(
        BookDatabaseConstants.readingTimeTableName,
        columns: ['COUNT(*)'],
        where: '${BookDatabaseConstants.columnBookId} = ?',
        whereArgs: [bookId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    });
  }

  @override
  Future<int> getReadingTimeForTimePeriod(
      DateTime startDate, DateTime endDate) async {
    final db = await bookDatabase.database;

    final result = await db.query(
      BookDatabaseConstants.readingTimeTableName,
      columns: ['COUNT(DISTINCT ${BookDatabaseConstants.columnDate})'],
      where: '${BookDatabaseConstants.columnDate} >= ? AND ${BookDatabaseConstants.columnDate} <= ?',
      whereArgs: [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<int> getTotalReadingTime() async {
    final db = await bookDatabase.database;

    final result = await db.query(
      BookDatabaseConstants.readingTimeTableName,
      columns: ['COUNT(DISTINCT ${BookDatabaseConstants.columnDate})'],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  List<DateTime> getReadingDaysForBook(Book book) {
    if (book.status != BookStatus.finished) {
      throw Exception('Book is not finished yet');
    }

    var startDate = DateTime(
        book.startDate!.year, book.startDate!.month, book.startDate!.day);
    var endDate = DateTime(
        book.finishDate!.year, book.finishDate!.month, book.finishDate!.day);

    List<DateTime> readingDays = [];

    while (startDate.isBefore(endDate)) {
      readingDays.add(startDate);
      startDate = startDate.add(const Duration(days: 1));
    }

    readingDays.add(endDate);

    return readingDays;
  }
}
