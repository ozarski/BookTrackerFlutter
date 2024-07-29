import 'package:flutter/foundation.dart';

class Book {
  String title;
  String author;
  int pages;
  BookStatus status = BookStatus.reading;
  DateTime? startDate;
  DateTime? finishDate;
  int progress = 0;
  int id = -1;
  String thumbnail = '';

  Book({
    required this.title,
    required this.author,
    required this.pages,
    this.status = BookStatus.reading,
    this.startDate,
    this.finishDate,
    this.progress = 0,
    this.id = -1,
    this.thumbnail = '',
  });

  void setStartDate(DateTime startDate) {
    if (status != BookStatus.reading && status != BookStatus.finished) {
      return;
    }
    if (status == BookStatus.finished && startDate.isAfter(finishDate!)) {
      return;
    }
    this.startDate = startDate;
  }

  void setFinishDate(DateTime finishDate) {
    if (status != BookStatus.finished) {
      return;
    }
    if (startDate != null && finishDate.isBefore(startDate!)) {
      if (kDebugMode) {
        print('Finish date is before start date');
      }
      this.finishDate = startDate;
      return;
    }
    this.finishDate = finishDate;
  }

  void setStatus(BookStatus status) {
    this.status = status;
    if (status == BookStatus.finished) {
      finishDate ??= startDate ?? DateTime.now();
      startDate ??= DateTime.now();
    } else if (status == BookStatus.reading && startDate == null) {
      startDate = DateTime.now();
    } else if (finishDate != null &&
        startDate != null &&
        finishDate!.isBefore(startDate!)) {
      finishDate = startDate;
    }

    if (status == BookStatus.reading) {
      finishDate = null;
    } else if (status == BookStatus.wantToRead) {
      startDate = null;
      finishDate = null;
    }
  }

  @override
  String toString() {
    return 'Book{\ntitle: $title, \nauthor: $author, \npages: $pages, '
        '\nstatus: $status\nstartDate: $startDate, \nfinishDate: $finishDate, \nthumbnail: $thumbnail}, \nprogress: $progress\n}';
  }

  static Book addBookInit() {
    var book = Book(title: '', author: '', pages: 0);
    book.setStatus(BookStatus.reading);
    return book;
  }

  Book copyWith({
    String? title,
    String? author,
    int? pages,
    BookStatus? status,
    DateTime? startDate,
    DateTime? finishDate,
    int? progress,
    int? id,
    String? thumbnail,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      pages: pages ?? this.pages,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      progress: progress ?? this.progress,
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}

enum BookStatus {
  reading,
  finished,
  wantToRead;

  @override
  String toString() {
    switch (this) {
      case BookStatus.reading:
        return 'reading';
      case BookStatus.finished:
        return 'finished';
      case BookStatus.wantToRead:
        return 'want to read';
      default:
        return 'Unknown';
    }
  }
}
