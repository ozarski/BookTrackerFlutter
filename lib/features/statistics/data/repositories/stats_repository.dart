import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/core/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/statistics/domain/repositories/stats_repository_interface.dart';
import 'package:sqflite/sqflite.dart';

class StatsRepository implements StatsRepositoryInterface {
  final BookDatabase database;

  StatsRepository(this.database);

  @override
  Future<int> getBooksCount() async {
    var db = await database.database;

    var result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${BookDatabaseConstants.booksTableName} '
      'WHERE ${BookDatabaseConstants.columnStatus} = \'1\'',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<double> getAverageReadingTime() async {
    var db = await database.database;

    var query = 'SELECT (SUM('
        '((${BookDatabaseConstants.columnFinishDate} - ${BookDatabaseConstants.columnStartDate})/1000/60/60/24) + 1.0'
        ')/COUNT(*)) FROM ${BookDatabaseConstants.booksTableName} WHERE ${BookDatabaseConstants.columnStatus} = \'1\'';

    var result = await db.rawQuery(query);
    if(result.first.values.first == null) {
      return 0;
    }
    return result.first.values.first as double;
  }

  @override
  Future<double> getBooksPerMonth() async {
    var db = await database.database;

    var query = 'SELECT (COUNT(*)/SUM( '
        '((${BookDatabaseConstants.columnFinishDate} - ${BookDatabaseConstants.columnStartDate})/1000/60/60/24) + 1.0)) * 30 '
        'FROM ${BookDatabaseConstants.booksTableName} WHERE ${BookDatabaseConstants.columnStatus} = \'1\';';

    var result = await db.rawQuery(query);
    if(result.first.values.first == null) {
      return 0;
    }
    return result.first.values.first as double;
  }

  @override
  Future<double> getBooksPerWeek() async {
    var db = await database.database;

    var query = 'SELECT (COUNT(*)/SUM( '
        '((${BookDatabaseConstants.columnFinishDate} - ${BookDatabaseConstants.columnStartDate})/1000/60/60/24) + 1.0)) * 7 '
        'FROM ${BookDatabaseConstants.booksTableName} WHERE ${BookDatabaseConstants.columnStatus} = \'1\';';

    var result = await db.rawQuery(query);
    if(result.first.values.first == null) {
      return 0;
    }
    return result.first.values.first as double;
  }

  @override
  Future<double> getPagesPerBook() async {
    var db = await database.database;

    var query = 'SELECT (CAST(SUM(${BookDatabaseConstants.columnPages}) as REAL)/COUNT(*)) '
        'FROM ${BookDatabaseConstants.booksTableName} WHERE ${BookDatabaseConstants.columnStatus} = \'1\';';

    var result = await db.rawQuery(query);
    if(result.first.values.first == null) {
      return 0;
    }
    return result.first.values.first as double;
  }

  @override
  Future<double> getPagesPerDay() async {
    var db = await database.database;

    var query = 'SELECT (CAST(SUM(${BookDatabaseConstants.columnPages}) as REAL)/SUM( '
        '((${BookDatabaseConstants.columnFinishDate} - ${BookDatabaseConstants.columnStartDate})/1000/60/60/24) + 1.0)) '
        'FROM ${BookDatabaseConstants.booksTableName} WHERE ${BookDatabaseConstants.columnStatus} = \'1\';';

    var result = await db.rawQuery(query);
    if(result.first.values.first == null) {
      return 0;
    }
    return result.first.values.first as double;
  }

  @override
  Future<int> getTotalPages() async {
    var db = await database.database;

    var result = await db.rawQuery(
      'SELECT SUM(${BookDatabaseConstants.columnPages}) FROM ${BookDatabaseConstants.booksTableName} '
      'WHERE ${BookDatabaseConstants.columnStatus} = \'1\'',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
