import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/repositories/book_repository_interface.dart';

class DisplayBookDetailsUseCase implements UseCase<Book, int> {
  final BookRepositoryInterface repository;

  DisplayBookDetailsUseCase(this.repository);

  @override
  Future<Book> call(int id) async {
    return await repository.getBook(id);
  }
}