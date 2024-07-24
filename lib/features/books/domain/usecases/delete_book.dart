import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/books/data/repositories/book_repository.dart';

class DeleteBookUseCase implements UseCase<void, int>{
  final BookRepository _bookRepository;

  DeleteBookUseCase(this._bookRepository);

  @override
  Future<void> call(int id) async {
    return _bookRepository.deleteBook(id);
  }
}