import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/repositories/book_repository_interface.dart';

class DisplayBookListUseCase implements UseCaseNoParams<List<Book>> {
  final BookRepositoryInterface repository;

  DisplayBookListUseCase(this.repository);

  @override
  Future<List<Book>> call() async {
    final books = await repository.getBooks();
    return sortBooks(books);
  }

  List<Book> sortBooks(List<Book> books) {
    var finishedBooks = books.where((book) => book.status == BookStatus.finished).toList();
    var readingBooks = books.where((book) => book.status == BookStatus.reading).toList();
    var wantToReadBooks = books.where((book) => book.status == BookStatus.wantToRead).toList();

    finishedBooks.sort((book1, book2) => book1.finishDate!.compareTo(book2.finishDate!));
    finishedBooks = finishedBooks.reversed.toList();
    readingBooks.sort((book1, book2) => book1.startDate!.compareTo(book2.startDate!));
    readingBooks = readingBooks.reversed.toList();
    wantToReadBooks.sort((book1, book2) => book1.title.compareTo(book2.title));

    return [...readingBooks, ...finishedBooks, ...wantToReadBooks];
  }
}