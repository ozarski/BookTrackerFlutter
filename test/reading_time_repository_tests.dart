import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/core/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/books/data/repositories/reading_time_repository.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

late BookDatabase bookDatabase;
late ReadingTimeRepository readingTimeRepository;

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    bookDatabase = BookDatabase.instance;
    readingTimeRepository = ReadingTimeRepository(bookDatabase);
  });

  tearDownAll(() async {
    await bookDatabase.close();
    final dbPath = await BookDatabase.instance.database.then((db) => db.path);
    await databaseFactory.deleteDatabase(dbPath);
  });

  tearDown(() async {
    await BookDatabase.instance.database
        .then((db) => db.delete(BookDatabaseConstants.readingTimeTableName));
  });

  test('get reading days for book', () {
    final book = Book(
      id: 1,
      title: 'Test Book',
      author: 'Test Author',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      finishDate: DateTime.now(),
    );

    final readingDays = readingTimeRepository.getReadingDaysForBook(book);

    expect(readingDays.length, 6);
    expect(
        readingDays.where((day) {
          return day.hour == 0 && day.minute == 0 && day.second == 0;
        }).length,
        6);
  });

  test('add reading time for single book', () async {
    final book = Book(
      id: 1,
      title: 'Test Book',
      author: 'Test Author',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      finishDate: DateTime.now(),
    );

    readingTimeRepository.addReadingTimeForBook(book);

    const readingTimeQuery = '''
      SELECT * FROM ${BookDatabaseConstants.readingTimeTableName}
    ''';

    final readingTime =
        await bookDatabase.database.then((db) => db.rawQuery(readingTimeQuery));
    expect(readingTime.length, 6);
  });

  test('get reading time for book', () async {
    final book = Book(
      id: 1,
      title: 'Test Book',
      author: 'Test Author',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      finishDate: DateTime.now(),
    );

    readingTimeRepository.addReadingTimeForBook(book);

    final readingTime = await readingTimeRepository.getReadingTimeForBook(1);

    expect(readingTime, 6);
  });

  test('add reading time for multiple books', () async {
    final book1 = Book(
      id: 1,
      title: 'Test Book 1',
      author: 'Test Author 1',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      finishDate: DateTime.now(),
    );

    final book2 = Book(
      id: 2,
      title: 'Test Book 2',
      author: 'Test Author 2',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      finishDate: DateTime.now(),
    );

    readingTimeRepository.addReadingTimeForBook(book1);
    readingTimeRepository.addReadingTimeForBook(book2);

    const readingTimeQuery = '''
      SELECT * FROM ${BookDatabaseConstants.readingTimeTableName}
    ''';
    final readingTime =
        await bookDatabase.database.then((db) => db.rawQuery(readingTimeQuery));
    expect(readingTime.length, 17);

    final readingTimeForBook1 =
        await readingTimeRepository.getReadingTimeForBook(1);
    final readingTimeForBook2 =
        await readingTimeRepository.getReadingTimeForBook(2);

    expect(readingTimeForBook1, 6);
    expect(readingTimeForBook2, 11);
  });

  test('get reading time for time period', () async {
    final book1 = Book(
      id: 1,
      title: 'Test Book 1',
      author: 'Test Author 1',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      finishDate: DateTime.now(),
    );

    final book2 = Book(
      id: 2,
      title: 'Test Book 2',
      author: 'Test Author 2',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      finishDate: DateTime.now(),
    );

    readingTimeRepository.addReadingTimeForBook(book1);
    readingTimeRepository.addReadingTimeForBook(book2);

    final startDate = DateTime.now().subtract(const Duration(days: 9));
    final endDate = DateTime.now();

    final readingTimeForTimePeriod = await readingTimeRepository
        .getReadingTimeForTimePeriod(startDate, endDate);
    
    expect(readingTimeForTimePeriod, 9);
  });

  test('delete reading time for book', () async {
    final book1 = Book(
      id: 1,
      title: 'Test Book 1',
      author: 'Test Author 1',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      finishDate: DateTime.now(),
    );
    final book2 = Book(
      id: 2,
      title: 'Test Book 2',
      author: 'Test Author 2',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      finishDate: DateTime.now(),
    );

    readingTimeRepository.addReadingTimeForBook(book1);
    readingTimeRepository.addReadingTimeForBook(book2);

    await readingTimeRepository.deleteReadingTimeForBook(1);

    final readingTime = await readingTimeRepository.getReadingTimeForBook(2);
    expect(readingTime, 11);

    const readingTimeQuery = '''
      SELECT * FROM ${BookDatabaseConstants.readingTimeTableName}
    ''';

    final readingTimeRows = await bookDatabase.database
        .then((db) => db.rawQuery(readingTimeQuery));
    expect(readingTimeRows.length, 11);
  });

  test('get total reading time', () async {
    final book1 = Book(
      id: 1,
      title: 'Test Book 1',
      author: 'Test Author 1',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      finishDate: DateTime.now(),
    );

    final book2 = Book(
      id: 2,
      title: 'Test Book 2',
      author: 'Test Author 2',
      pages: 100,
      status: BookStatus.finished,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      finishDate: DateTime.now(),
    );

    readingTimeRepository.addReadingTimeForBook(book1);
    readingTimeRepository.addReadingTimeForBook(book2);

    final totalReadingTime = await readingTimeRepository.getTotalReadingTime();
    expect(totalReadingTime, 11);
  });
}
