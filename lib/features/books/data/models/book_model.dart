import 'package:book_tracker/features/books/data/data_sources/book_database.dart';
import 'package:book_tracker/features/books/data/data_sources/book_database_constants.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    int? id,
    required super.title,
    required super.author,
    required super.pages,
    required super.status,
    super.startDate,
    super.finishDate,
    int? progress,
  }) : super(
          id: id ?? -1,
          progress: progress ?? 0,
        );

  Map<String, Object?> toMap() {
    return {
      BookDatabaseConstants.columnTitle: title,
      BookDatabaseConstants.columnAuthor: author,
      BookDatabaseConstants.columnPages: pages,
      BookDatabaseConstants.columnStatus: status.index,
      BookDatabaseConstants.columnStartDate: startDate?.millisecondsSinceEpoch,
      BookDatabaseConstants.columnFinishDate:
          finishDate?.millisecondsSinceEpoch,
      BookDatabaseConstants.columnProgress: progress,
    };
  }

  factory BookModel.fromMap(Map<String, Object?> map) {
    return BookModel(
      id: map[BookDatabaseConstants.columnId] as int?,
      title: map[BookDatabaseConstants.columnTitle] as String,
      author: map[BookDatabaseConstants.columnAuthor] as String,
      pages: map[BookDatabaseConstants.columnPages] as int,
      status: BookStatus.values[map[BookDatabaseConstants.columnStatus] as int],
      startDate: map[BookDatabaseConstants.columnStartDate] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              map[BookDatabaseConstants.columnStartDate] as int),
      finishDate: map[BookDatabaseConstants.columnFinishDate] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              map[BookDatabaseConstants.columnFinishDate] as int),
      progress: map[BookDatabaseConstants.columnProgress] as int,
    );
  }

  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      pages: book.pages,
      status: book.status,
      startDate: book.startDate,
      finishDate: book.finishDate,
      progress: book.progress,
    );
  }
}
