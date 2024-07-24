import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/repositories/book_repository_interface.dart';

class UpdateBookProgressUseCase implements UseCase<Book, List<int>> {
  final BookRepositoryInterface repository;

  UpdateBookProgressUseCase(this.repository);

  @override
  Future<Book> call(List<int> params) async {
    var book = await repository.getBook(params[0]);
    book.progress = params[1];
    return await repository.updateBook(book);
  }
}