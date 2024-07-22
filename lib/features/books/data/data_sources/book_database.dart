import 'package:book_tracker/features/books/data/data_sources/book_database_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookDatabase{
  BookDatabase._privateConstructor();
  static final BookDatabase instance = BookDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
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
}