import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/core/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/books/data/repositories/book_repository.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/statistics/data/repositories/stats_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

late BookDatabase database;
late StatsRepository statsRepository;

void main() {
  setUp(() async {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;

    database = BookDatabase.instance;
    statsRepository = StatsRepository(database);

    await generateMockBooks();
  });

  tearDownAll(() async {
    await BookDatabase.instance.database.then((db) => db.close());
    //delete database file
    final dbPath = await BookDatabase.instance.database.then((db) => db.path);
    await databaseFactory.deleteDatabase(dbPath);
  });

  tearDown(() async {
    //delete all books
    await BookDatabase.instance.database.then((db) => db.delete(BookDatabaseConstants.booksTableName));
  });


  test('getBooksCount', () async {
    int booksCount = await statsRepository.getBooksCount();
    expect(booksCount, 3);
  });

  test('getTotalPages', () async {
    int totalPages = await statsRepository.getTotalPages();
    expect(totalPages, 700);
  });

  test('getPagesPerBook', () async {
    double pagesPerBook = await statsRepository.getPagesPerBook();
    expect(pagesPerBook, closeTo(233.33, 0.01));
  });

  test('getPagesPerDay', () async {
    double pagesPerDay = await statsRepository.getPagesPerDay();
    expect(pagesPerDay, 20);
  });

  test('getAverageReadingTime', () async {
    double averageReadingTime = await statsRepository.getAverageReadingTime();
    expect(averageReadingTime, closeTo(11.66, 0.01));
  });

  test('getBooksPerMonth', () async {
    double booksPerMonth = await statsRepository.getBooksPerMonth();
    expect(booksPerMonth, closeTo(2.57, 0.01));
  });

  test('getBooksPerWeek', () async {
    double booksPerWeek = await statsRepository.getBooksPerWeek();
    expect(booksPerWeek, closeTo(0.6, 0.01));
  });
}

Future<List<Book>> generateMockBooks() async {
  List<Book> books = [
    Book(
      title: "Book 1",
      author: "Author 1",
      pages: 100,
      startDate: DateTime.now(),
      finishDate: DateTime.now().add(const Duration(days: 9)),
      status: BookStatus.finished,
      progress: 100,
    ),
    Book(
      title: "Book 2",
      author: "Author 2",
      pages: 200,
      startDate: DateTime.now(),
      finishDate: DateTime.now().add(const Duration(days: 19)),
      status: BookStatus.finished,
      progress: 100,
    ),
    Book(
      title: "Book 3",
      author: "Author 3",
      pages: 300,
      startDate: DateTime.now(),
      finishDate: null,
      status: BookStatus.reading,
      progress: 50,
    ),
    Book(
      title: "Book 4",
      author: "Author 4",
      pages: 400,
      startDate: DateTime.now(),
      finishDate: DateTime.now().add(const Duration(days: 4)),
      status: BookStatus.finished,
      progress: 100,
    ),
  ];

  var booksRepo = BookRepository(database);
  for (Book book in books) {
    await booksRepo.addBook(book);
  }

  return books;
}
