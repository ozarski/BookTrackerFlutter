import 'dart:io';

import 'package:book_tracker/core/data_sources/book_database_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookDatabase{
  BookDatabase._privateConstructor();
  static final BookDatabase instance = BookDatabase._privateConstructor();

  late Database _database;
  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var path = join(await getDatabasesPath(), BookDatabaseConstants.databaseName);
    return await openDatabase(
      path,
      onCreate: onCreate,
      version: BookDatabaseConstants.databaseVersion,
    );
  }

  void onCreate(Database db, int version) {
    db.execute(
      BookDatabaseConstants.createBookTableQuery
    );
    db.execute(
      BookDatabaseConstants.createReadingTimeTableQuery
    );
  }

  Future<void> close() async {
    await _database.close();
  }

  Future<bool> importedDatabaseSchemaCheck(String importedDatabaseName) async {
    var path = join(await getDatabasesPath(), importedDatabaseName);
    try{
      await openDatabase(path);
    } catch (e){
      return false;
    }
    var importedDatabase = await openDatabase(path);

    var importedTables = await importedDatabase.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
    var importedTableNames = importedTables.map((table) => table['name']).toList();
    if(!importedTableNames.contains(BookDatabaseConstants.booksTableName)) return false;
    if(!importedTableNames.contains(BookDatabaseConstants.readingTimeTableName)) return false;

    var importedBookTableColumns = await importedDatabase.rawQuery('PRAGMA table_info(books)');
    var importedBookTableColumnNames = importedBookTableColumns.map((column) => column['name']).toList();
    var bookTableColumnNames = [
      BookDatabaseConstants.columnAuthor,
      BookDatabaseConstants.columnTitle,
      BookDatabaseConstants.columnThumbnail,
      BookDatabaseConstants.columnPages,
      BookDatabaseConstants.columnStatus,
      BookDatabaseConstants.columnProgress,
      BookDatabaseConstants.columnStartDate,
      BookDatabaseConstants.columnFinishDate,
    ];
    for(var columnName in bookTableColumnNames){
      if(!importedBookTableColumnNames.contains(columnName)) return false;
    }

    var importedReadingTimeTableColumns = await importedDatabase.rawQuery('PRAGMA table_info(${BookDatabaseConstants.readingTimeTableName})');
    var importedReadingTimeTableColumnNames = importedReadingTimeTableColumns.map((column) => column['name']).toList();
    var readingTimeTableColumnNames = [
      BookDatabaseConstants.columnDate,
      BookDatabaseConstants.columnBookId,
    ];
    for(var columnName in readingTimeTableColumnNames){
      if(!importedReadingTimeTableColumnNames.contains(columnName)) return false;
    }

    await importedDatabase.close();

    // if all checks pass, replace the current database with the imported one
    await _database.close();
    await deleteDatabase(join(await getDatabasesPath(), BookDatabaseConstants.databaseName));
    await File(importedDatabase.path).copy(join(await getDatabasesPath(), BookDatabaseConstants.databaseName)); 

    return true;
  }
}