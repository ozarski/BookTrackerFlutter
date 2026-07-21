import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/usecases/delete_book.dart';
import 'package:book_tracker/features/books/domain/usecases/display_book_details.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_progress.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_status.dart';
import 'package:book_tracker/features/search_books/data/data_sources/google_books_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookStateModel extends ChangeNotifier {
  final DisplayBookDetailsUseCase displayBookDetailsUseCase;
  final UpdateBookProgressUseCase updateBookProgressUseCase;
  final UpdateBookStatusUseCase updateBookStatusUseCase;
  final DeleteBookUseCase deleteBookUseCase;
  final UpdateBookUseCase updateBookUseCase;
  final GoogleBooksApiService googleBooksApiService;
  final int id;

  Book? book;
  bool _isFetchingCover = false;
  bool get isFetchingCover => _isFetchingCover;
  String? _coverError;
  String? get coverError => _coverError;

  BookStateModel({
    required this.displayBookDetailsUseCase,
    required this.updateBookProgressUseCase,
    required this.updateBookStatusUseCase,
    required this.deleteBookUseCase,
    required this.updateBookUseCase,
    required this.googleBooksApiService,
    required this.id,
  }) {
    _getBookDetails(id);
  }

  Future<void> _getBookDetails(int id) async {
    book = await displayBookDetailsUseCase(id);
    notifyListeners();
  }

  String getBookTitle() {
    return book?.title ?? '';
  }

  String getBookAuthor() {
    return book?.author ?? '';
  }

  int getBookPages() {
    return book?.pages ?? 0;
  }

  int getBookProgress() {
    return book?.progress ?? 0;
  }

  BookStatus getBookStatus() {
    return book?.status ?? BookStatus.wantToRead;
  }

  DateTime? getStartDate() {
    return book?.startDate;
  }

  DateTime? getFinishDate() {
    return book?.finishDate;
  }

  int getID() {
    return book?.id ?? 0;
  }

  String getThumbnail() {
    return book?.thumbnail ?? '';
  }

  String getFormattedStartDate() {
    if (book == null) return '';
    return book?.startDate != null
        ? DateFormat('dd.MM.yyyy').format(book!.startDate!)
        : '';
  }

  String getEstimatedReadingTime() {
    if (book == null) return '';
    if (book?.pages == null || book?.pages == 0) return '';
    if (book?.progress == null) return '';
    if (book?.progress == 0) return '';
    final pagesToRead = book!.pages - book!.progress;
    final readingTimeSoFar = book!.startDate != null
        ? DateTime.now().difference(book!.startDate!).inDays + 1
        : Duration.zero.inDays + 1;
    final days = (readingTimeSoFar / book!.progress * pagesToRead).ceil();
    return '$days days';
  }

  String getFormattedFinishDate() {
    if (book == null) return '';
    return book?.finishDate != null
        ? DateFormat('dd.MM.yyyy').format(book!.finishDate!)
        : '';
  }

  void updateProgress(int progress) async {
    book?.progress = progress;
    notifyListeners();
  }

  void saveProgress(int progress) async {
    book?.progress = progress;
    if (book != null) {
      await updateBookProgressUseCase([book!.id, progress.toInt()]);
    }
  }

  void setStatus(BookStatus status) async {
    if (status == BookStatus.finished && book?.finishDate == null) {
      book?.finishDate = DateTime.now();
    } else if (status == BookStatus.reading && book?.startDate == null) {
      book?.startDate = DateTime.now();
    }
    book?.status = status;
    if (book != null) await updateBookStatusUseCase(book!);
    notifyListeners();
  }

  void deleteBook() {
    deleteBookUseCase(id);
  }

  Future<void> fetchCover() async {
    if (book == null || book!.title.isEmpty) return;
    _isFetchingCover = true;
    _coverError = null;
    notifyListeners();

    try {
      var searchQuery = book!.author.isNotEmpty
          ? '${book!.title} ${book!.author}'
          : book!.title;
      var result = await googleBooksApiService.searchBooks(searchQuery);
      var items = result['items'] as List?;
      if (items == null || items.isEmpty) {
        _coverError = 'No cover found.';
        return;
      }
      var imageLinks =
          items[0]['volumeInfo']?['imageLinks'] as Map<String, dynamic>?;
      var thumbnail = imageLinks?['thumbnail'] as String?
          ?? imageLinks?['smallThumbnail'] as String?;
      if (thumbnail != null) {
        thumbnail = thumbnail
            .replaceAll('zoom=1', 'zoom=0')
            .replaceAll('zoom=5', 'zoom=0');
      }
      if (thumbnail == null || thumbnail.isEmpty) {
        _coverError = 'No cover found.';
        return;
      }
      var updatedBook = book!.copyWith(thumbnail: thumbnail);
      await updateBookUseCase(updatedBook);
      book = updatedBook;
    } catch (e) {
      _coverError = 'Failed to fetch cover.';
    } finally {
      _isFetchingCover = false;
      notifyListeners();
    }
  }

  Future<void> removeCover() async {
    if (book == null) return;
    var updatedBook = book!.copyWith(thumbnail: '');
    await updateBookUseCase(updatedBook);
    book = updatedBook;
    notifyListeners();
  }
}
