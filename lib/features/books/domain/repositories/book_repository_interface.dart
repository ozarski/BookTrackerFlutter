import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';

 abstract class BookRepositoryInterface {

    Future<List<Book>> getBooks();
    Future<Book> getBook(int id);
    Future<Book> addBook(Book book);
    Future<Book> updateBook(Book book);
    Future<void> deleteBook(int id);
    Future<List<Book>> getBooksFiltered(FilterBookListParams filter);
}