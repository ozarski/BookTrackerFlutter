import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/usecases/delete_book.dart';
import 'package:book_tracker/features/books/domain/usecases/display_book_details.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_progress.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookStateModel extends ChangeNotifier {
  final DisplayBookDetailsUseCase displayBookDetailsUseCase;
  final UpdateBookProgressUseCase updateBookProgressUseCase;
  final UpdateBookStatusUseCase updateBookStatusUseCase;
  final DeleteBookUseCase deleteBookUseCase;
  final int id;

  Book? book;

  BookStateModel(
      {required this.displayBookDetailsUseCase,
      required this.updateBookProgressUseCase,
      required this.updateBookStatusUseCase,
      required this.deleteBookUseCase,
      required this.id}) {
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

  int getID(){
    return book?.id ?? 0;
  }

  String getFormattedStartDate() {
    if (book == null) return '';
    return book?.startDate != null
        ? DateFormat('dd.MM.yyyy').format(book!.startDate!)
        : '';
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
}
