
import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/repositories/book_repository_interface.dart';

class AddBookUseCase implements UseCase<Book, Book> {
  final BookRepositoryInterface repository;
  AddBookUseCase(this.repository);

  @override
  Future<Book> call(Book book) async {
    return await repository.addBook(book);
  }
}