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
  }

  Future<void> close() async {
    await _database.close();
  }
}