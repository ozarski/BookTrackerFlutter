import 'package:book_tracker/core/errors/database_errors.dart';
import 'package:book_tracker/features/books/data/data_sources/book_database.dart';
import 'package:book_tracker/features/books/data/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/books/data/models/book_model.dart';
import 'package:book_tracker/features/books/domain/entities/repositories/book_repository_interface.dart';

import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:sqflite/sqflite.dart';

class BookRepository implements BookRepositoryInterface {
  @override
  Future<Book> addBook(Book book) async {
    final db = await BookDatabase.instance.database;
    if(validateBook(book) == false){
      throw InvalidBookInputError('Invalid book input');
    }
    var bookModel = BookModel.fromEntity(book); 

    bookModel.id = await db.insert('books', bookModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return bookModel;
  }

  @override
  Future<void> deleteBook(int id) async {
    final db = await BookDatabase.instance.database;

    final deletedBooks = await db.delete(
      BookDatabaseConstants.booksTableName,
      where: '${BookDatabaseConstants.columnId} = ?',
      whereArgs: [id],
    );

    if (deletedBooks == 0) {
      throw ObjectNotFoundError('Book not found');
    }
  }

  @override
  Future<Book> getBook(int id) async {
    final db = await BookDatabase.instance.database;
    var maps = await db.query(
      BookDatabaseConstants.booksTableName,
      where: '${BookDatabaseConstants.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw ObjectNotFoundError('Book not found');
    }

    return BookModel.fromMap(maps.first);
  }

  @override
  Future<List<Book>> getBooks() async {
    final db = BookDatabase.instance.database;

    final List<Map<String, Object?>> bookMaps = await (await db).query(BookDatabaseConstants.booksTableName);

    return [
      for (final bookMap in bookMaps) BookModel.fromMap(bookMap)
    ];
  }

  @override
  Future<Book> updateBook(Book book) async {
    if(validateBook(book) == false){
      throw InvalidBookInputError('Invalid book input');
    }
    final db = await BookDatabase.instance.database;

    var success = await db.update(
      BookDatabaseConstants.booksTableName,
      BookModel.fromEntity(book).toMap(),
      where: '${BookDatabaseConstants.columnId} = ?',
      whereArgs: [book.id],
    );

    if (success == 0) {
      throw ObjectNotFoundError('Book not found');
    }
    return book;
  }

  bool validateBook(Book book){
    if(book.title.isEmpty || book.author.isEmpty || book.pages <= 0){
      return false;
    }
    if(book.status == BookStatus.finished && (book.finishDate == null || book.startDate == null)){
      return false;
    }
    if(book.status == BookStatus.reading && (book.startDate == null || book.finishDate != null)){
      return false;
    }
    if(book.status == BookStatus.wantToRead && (book.startDate != null || book.finishDate != null)){
      return false;
    }
    if(book.startDate != null && book.finishDate != null && book.startDate!.isAfter(book.finishDate!)){
      return false;
    }
    return true;
  }
}
