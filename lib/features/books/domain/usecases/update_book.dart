import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/data/repositories/book_repository.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';

class UpdateBookUseCase implements UseCase<Book, Book> {
  final BookRepository _repository;

  UpdateBookUseCase(this._repository);

  @override
  Future<Book> call(Book params) async {
    return await _repository.updateBook(params);
  }
}