import 'package:book_tracker/core/errors/database_errors.dart';
import 'package:book_tracker/core/utils/date_comparison_extension.dart';
import 'package:book_tracker/features/books/data/data_sources/book_database.dart';
import 'package:book_tracker/features/books/data/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/books/data/models/book_model.dart';
import 'package:book_tracker/features/books/data/repositories/book_repository.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

late BookRepository bookRepository;
late BookDatabase bookDatabase;

Future main() async {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    bookDatabase = BookDatabase.instance;
    bookRepository = BookRepository(bookDatabase);
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

  group('test adding book', () {
    test(
      'addBook',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 100,
            status: BookStatus.finished,
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            progress: 100);

        final addedBookId = (await bookRepository.addBook(book)).id;
        final bookFromDB = await getBookById(
            addedBookId, await BookDatabase.instance.database);
        compareBooks(book, bookFromDB);
      },
    );

    test(
      'addBook with invalid title',
      () async {
        final book = Book(
            title: '',
            author: 'author',
            pages: 100,
            status: BookStatus.wantToRead);

        expect(
          () async {
            await bookRepository.addBook(book);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'addBook with invalid author',
      () async {
        final book = Book(
            title: 'title',
            author: '',
            pages: 100,
            status: BookStatus.wantToRead);

        expect(
          () async {
            await bookRepository.addBook(book);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'addBook with invalid number of pages',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 0,
            status: BookStatus.wantToRead);

        expect(
          () async {
            await bookRepository.addBook(book);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'addBook with invalid start date',
      () async {
        final book = Book(
          title: 'title',
          author: 'author',
          pages: 100,
          status: BookStatus.wantToRead,
          startDate: DateTime.now(),
        );

        expect(
          () async {
            await bookRepository.addBook(book);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'addBook with invalid finish date',
      () async {
        final book = Book(
          title: 'title',
          author: 'author',
          pages: 100,
          status: BookStatus.reading,
          startDate: DateTime.now(),
          finishDate: DateTime.now(),
        );

        expect(
          () async {
            await bookRepository.addBook(book);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'addBook with invalid dates',
      () async {
        final book = Book(
          title: 'title',
          author: 'author',
          pages: 100,
          status: BookStatus.reading,
          startDate: DateTime.now(),
          finishDate: DateTime.now().copyWith(day: DateTime.now().day - 1),
        );

        expect(
          () async {
            await bookRepository.addBook(book);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );
  });

  group('test retrieving book', () {
    test('get book by id', () async {
      final book = Book(
          title: 'title',
          author: 'author',
          pages: 100,
          status: BookStatus.finished,
          startDate: DateTime.now(),
          finishDate: DateTime.now(),
          progress: 100);

      final addedBookId = (await bookRepository.addBook(book)).id;
      final bookFromDB = await bookRepository.getBook(addedBookId);
      compareBooks(book, bookFromDB);
    });

    test('get book by id that does not exist', () async {
      expect(
        () async {
          await bookRepository.getBook(0);
        },
        throwsA(isA<ObjectNotFoundError>()),
      );
    });
  });

  group('test updating book', () {
    test('update book', () async {
      final book = Book(
          title: 'title',
          author: 'author',
          pages: 100,
          status: BookStatus.finished,
          startDate: DateTime.now(),
          finishDate: DateTime.now(),
          progress: 100);

      final addedBookId = (await bookRepository.addBook(book)).id;

      final updatedBook = Book(
        title: 'new title',
        author: 'new author',
        pages: 200,
        status: BookStatus.reading,
        startDate: DateTime.now(),
        finishDate: null,
        progress: 50,
        id: addedBookId,
      );

      final updatedBookFromDB = await bookRepository.updateBook(updatedBook);
      compareBooks(updatedBook, updatedBookFromDB);
    });

    test('update book that does not exist', () async {
      final book = Book(
          title: 'title',
          author: 'author',
          pages: 100,
          status: BookStatus.finished,
          startDate: DateTime.now(),
          finishDate: DateTime.now(),
          progress: 100);

      expect(
        () async {
          await bookRepository.updateBook(book);
        },
        throwsA(isA<ObjectNotFoundError>()),
      );
    });
    test(
      'update with invalid title',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 100,
            status: BookStatus.finished,
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            progress: 100);

        final addedBookId = (await bookRepository.addBook(book)).id;
        final bookFromDB = await bookRepository.getBook(addedBookId);

        final updatedBook = bookFromDB.copyWith(title: '');

        expect(
          () async {
            await bookRepository.updateBook(updatedBook);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'update with invalid author',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 100,
            status: BookStatus.finished,
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            progress: 100);

        final addedBookId = (await bookRepository.addBook(book)).id;
        final bookFromDB = await bookRepository.getBook(addedBookId);

        final updatedBook = bookFromDB.copyWith(author: '');

        expect(
          () async {
            await bookRepository.updateBook(updatedBook);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'update with invalid number of pages',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 100,
            status: BookStatus.finished,
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            progress: 100);

        final addedBookId = (await bookRepository.addBook(book)).id;
        final bookFromDB = await bookRepository.getBook(addedBookId);

        final updatedBook = bookFromDB.copyWith(pages: 0);

        expect(
          () async {
            await bookRepository.updateBook(updatedBook);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'update with invalid start date',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 100,
            status: BookStatus.reading,
            startDate: DateTime.now(),
            finishDate: null,
            progress: 100);

        final addedBookId = (await bookRepository.addBook(book)).id;
        final bookFromDB = await bookRepository.getBook(addedBookId);

        final updatedBook = bookFromDB.copyWith(status: BookStatus.wantToRead);

        expect(
          () async {
            await bookRepository.updateBook(updatedBook);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'update with invalid finish date',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 100,
            status: BookStatus.finished,
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            progress: 100);

        final addedBookId = (await bookRepository.addBook(book)).id;
        final bookFromDB = await bookRepository.getBook(addedBookId);

        final updatedBook = bookFromDB.copyWith(status: BookStatus.reading);

        expect(
          () async {
            await bookRepository.updateBook(updatedBook);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );

    test(
      'update with invalid dates',
      () async {
        final book = Book(
            title: 'title',
            author: 'author',
            pages: 100,
            status: BookStatus.finished,
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            progress: 100);

        final addedBookId = (await bookRepository.addBook(book)).id;
        final bookFromDB = await bookRepository.getBook(addedBookId);

        final updatedBook = bookFromDB.copyWith(
            finishDate: DateTime.now().copyWith(day: DateTime.now().day - 1));

        expect(
          () async {
            await bookRepository.updateBook(updatedBook);
          },
          throwsA(isA<InvalidBookInputError>()),
        );
      },
    );
  });

  group('test deleting book', () {
    test('delete book', () async {
      final book = Book(
          title: 'title',
          author: 'author',
          pages: 100,
          status: BookStatus.finished,
          startDate: DateTime.now(),
          finishDate: DateTime.now(),
          progress: 100);

      final addedBookId = (await bookRepository.addBook(book)).id;
      await bookRepository.deleteBook(addedBookId);

      expect(
        () async {
          await bookRepository.getBook(addedBookId);
        },
        throwsA(isA<ObjectNotFoundError>()),
      );
    });

    test('delete book that does not exist', () async {
      expect(
        () async {
          await bookRepository.deleteBook(0);
        },
        throwsA(isA<ObjectNotFoundError>()),
      );
    });
  });

  group('test retrieving all books', () {
    test('get all books', () async {
      final books = List.generate(
        10,
        (index) => Book(
          title: 'title$index',
          author: 'author$index',
          pages: 100 + index,
          status: BookStatus.finished,
          startDate: DateTime.now(),
          finishDate: DateTime.now(),
          progress: 100,
        ),
      );

      for (final book in books) {
        await bookRepository.addBook(book);
      }

      final booksFromDB = await bookRepository.getBooks();
      expect(booksFromDB.length, books.length);
    });

    test('get all books when there are no books', () async {
      final booksFromDB = await bookRepository.getBooks();
      expect(booksFromDB.length, 0);
    });
  });
}

Future<Book> getBookById(int id, Database db) async {
  final query = await db.query(
    BookDatabaseConstants.booksTableName,
    where: '${BookDatabaseConstants.columnId} = ?',
    whereArgs: [id],
  );

  return BookModel.fromMap(query.first);
}

bool compareBooks(Book expected, Book actual) {
  expect(actual.title, expected.title);
  expect(actual.author, expected.author);
  expect(actual.pages, expected.pages);
  expect(actual.progress, expected.progress);
  if (actual.startDate != null) {
    expect(actual.startDate?.isSameDate(expected.startDate), true);
  }
  if (actual.finishDate != null) {
    expect(actual.finishDate?.isSameDate(expected.finishDate), true);
  }
  expect(actual.status, expected.status);
  expect(actual.id, isNotNull);

  return true;
}
