import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/repositories/book_repository_interface.dart';

class DisplayBookListUseCase implements UseCaseNoParams<List<Book>> {
  final BookRepositoryInterface repository;

  DisplayBookListUseCase(this.repository);

  @override
  Future<List<Book>> call() async {
    return await repository.getBooks();
  }
}