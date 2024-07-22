import 'package:book_tracker/features/books/domain/entities/book.dart';

 abstract class BookRepositoryInterface {

    Future<List<Book>> getBooks();
    Future<Book> getBook(int id);
    Future<Book> addBook(Book book);
    Future<Book> updateBook(Book book);
    Future<void> deleteBook(int id);
}