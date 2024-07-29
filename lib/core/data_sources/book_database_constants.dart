abstract class BookDatabaseConstants {
  static const String databaseName = 'book_database.db';
  static const int databaseVersion = 1;

  static const String booksTableName = 'books';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnAuthor = 'author';
  static const String columnPages = 'pages';
  static const String columnStatus = 'status';
  static const String columnStartDate = 'start_date';
  static const String columnFinishDate = 'finish_date';
  static const String columnProgress = 'progress';
  static const String columnThumbnail = 'thumbnail';

  static const String readingTimeTableName = 'reading_time';
  static const String columnDate = 'date';
  static const String columnBookId = 'book_id';


  static const String createBookTableQuery = '''
    CREATE TABLE $booksTableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTitle TEXT NOT NULL,
      $columnAuthor TEXT NOT NULL,
      $columnPages INTEGER NOT NULL,
      $columnStatus INTEGER NOT NULL,
      $columnStartDate INTEGER,
      $columnFinishDate INTEGER,
      $columnProgress INTEGER,
      $columnThumbnail TEXT
    )
  ''';

  static const String createReadingTimeTableQuery = '''
    CREATE TABLE $readingTimeTableName (
      $columnDate INTEGER NOT NULL,
      $columnBookId INTEGER NOT NULL,
      FOREIGN KEY ($columnBookId) REFERENCES $booksTableName($columnId)
    )
  ''';
}