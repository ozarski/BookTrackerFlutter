import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/core/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/books/data/repositories/reading_time_repository.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/statistics/domain/repositories/stats_repository_interface.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class StatsRepository implements StatsRepositoryInterface {
  final BookDatabase database;

  StatsRepository(this.database);

  @override
  Future<int> getBooksCount() async {
    var db = await database.database;

    var result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${BookDatabaseConstants.booksTableName} '
      'WHERE ${BookDatabaseConstants.columnStatus} = \'${BookStatus.finished.index}\'',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<double> getAverageReadingTime() async {
    var db = await database.database;

    var query = 'SELECT (SUM('
        '((${BookDatabaseConstants.columnFinishDate} - ${BookDatabaseConstants.columnStartDate})/1000/60/60/24) + 1.0'
        ')/COUNT(*)) FROM ${BookDatabaseConstants.booksTableName} WHERE ${BookDatabaseConstants.columnStatus} = \'${BookStatus.finished.index}\'';

    var result = await db.rawQuery(query);
    if (result.first.values.first == null) {
      return 0;
    }
    return result.first.values.first as double;
  }

  @override
  Future<double> getBooksPerMonth() async {
    final booksCount = await getBooksCount();
    final ReadingTimeRepository readingTimeRepository =
        ReadingTimeRepository(database);
    final totalReadingTime = await readingTimeRepository.getTotalReadingTime();

    if (totalReadingTime == 0) {
      return 0;
    }

    final booksPerDay = booksCount / totalReadingTime;

    return booksPerDay * 30;
  }

  @override
  Future<double> getBooksPerWeek() async {
    final booksCount = await getBooksCount();

    final ReadingTimeRepository readingTimeRepository =
        ReadingTimeRepository(database);
    final totalReadingTime = await readingTimeRepository.getTotalReadingTime();

    if (totalReadingTime == 0) {
      return 0;
    }

    final booksPerDay = booksCount / totalReadingTime;

    return booksPerDay * 7;
  }

  @override
  Future<double> getPagesPerBook() async {
    var db = await database.database;

    var query =
        'SELECT (CAST(SUM(${BookDatabaseConstants.columnPages}) as REAL)/COUNT(*)) '
        'FROM ${BookDatabaseConstants.booksTableName} WHERE ${BookDatabaseConstants.columnStatus} = \'${BookStatus.finished.index}\';';

    var result = await db.rawQuery(query);
    if (result.first.values.first == null) {
      return 0;
    }
    return result.first.values.first as double;
  }

  @override
  Future<double> getPagesPerDay() async {
    final totalPages = await getTotalPages();
    final ReadingTimeRepository readingTimeRepository =
        ReadingTimeRepository(database);
    final totalReadingTime = await readingTimeRepository.getTotalReadingTime();

    if (totalReadingTime == 0) {
      return 0;
    }

    return totalPages / totalReadingTime;
  }

  @override
  Future<int> getTotalPages() async {
    var db = await database.database;

    var result = await db.rawQuery(
      'SELECT SUM(${BookDatabaseConstants.columnPages}) FROM ${BookDatabaseConstants.booksTableName} '
      'WHERE ${BookDatabaseConstants.columnStatus} = \'${BookStatus.finished.index}\'',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<double> getBooksPerYear() async {
    final booksCount = await getBooksCount();

    final ReadingTimeRepository readingTimeRepository =
        ReadingTimeRepository(database);
    final totalReadingTime = await readingTimeRepository.getTotalReadingTime();
    if (totalReadingTime == 0) {
      return 0;
    }

    final booksPerDay = booksCount / totalReadingTime;

    return booksPerDay * 365;
  }

  @override
  Future<int> booksReadInMonth(int month, int year) async {
    final db = await database.database;
    final monthStart = DateTime(year, month, 1).millisecondsSinceEpoch;
    final monthEnd = DateTime(year, month + 1, 1).millisecondsSinceEpoch;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${BookDatabaseConstants.booksTableName} '
      'WHERE ${BookDatabaseConstants.columnStatus} = \'${BookStatus.finished.index}\' '
      'AND ${BookDatabaseConstants.columnFinishDate} >= $monthStart AND ${BookDatabaseConstants.columnFinishDate} < $monthEnd',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<int> booksReadInYear(int year) async {
    final db = await database.database;
    final yearStart = DateTime(year, 1, 1).millisecondsSinceEpoch;
    final yearEnd = DateTime(year + 1, 1, 1).millisecondsSinceEpoch;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${BookDatabaseConstants.booksTableName} '
      'WHERE ${BookDatabaseConstants.columnStatus} = \'${BookStatus.finished.index}\' '
      'AND ${BookDatabaseConstants.columnFinishDate} >= $yearStart AND ${BookDatabaseConstants.columnFinishDate} < $yearEnd',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<int> booksToBeReadThisYear([DateTime? date]) async {
    //optional parameter used only for testing
    final currentDate = date ?? DateTime.now();
    final bookCount = await getBooksCount();
    final readingTimeRepository = ReadingTimeRepository(database);
    final totalReadingTime = await readingTimeRepository.getTotalReadingTime();

    if (totalReadingTime == 0) {
      return 0;
    }

    final booksPerDay = bookCount / totalReadingTime;
    final daysLeft = (currentDate.year % 4 == 0 ? 366 : 365) - int.parse(DateFormat('D').format(currentDate));

    return (booksPerDay * daysLeft).round() + bookCount;
  }

  @override
  Future <Map<int, int>> booksReadEachMonthForYear(int year) async {
    final db = await database.database;

    final query = '''SELECT 
strftime('%m', datetime(${BookDatabaseConstants.columnFinishDate} / 1000, 'unixepoch')) AS month,
COUNT(*) AS count 
FROM ${BookDatabaseConstants.booksTableName}
WHERE strftime('%Y', datetime(${BookDatabaseConstants.columnFinishDate} / 1000, 'unixepoch')) = '$year' 
AND status = '${BookStatus.finished.index}'
GROUP BY month;''';

    final result = await db.rawQuery(query);
    
    var resultsToMap = <int, int>{};

    for (var row in result) {
      resultsToMap[int.parse(row['month'] as String)] = row['count'] as int;
    }

    for (var i = 1; i <= 12; i++) {
      if (!resultsToMap.containsKey(i)) {
        resultsToMap[i] = 0;
      }
    }

    resultsToMap = Map.fromEntries(resultsToMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    return resultsToMap;
  }
}
