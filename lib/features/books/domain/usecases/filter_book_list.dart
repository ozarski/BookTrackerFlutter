import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/data/repositories/book_repository.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';

class FilterBookListUseCase implements UseCase<List<Book>, FilterBookListParams> {
  final BookRepository repository;

  FilterBookListUseCase(this.repository);

  @override
  Future<List<Book>> call(FilterBookListParams params) async {
    final books = await repository.getBooksFiltered(params);
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

