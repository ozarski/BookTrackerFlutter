class Book {
  String title;
  String author;
  int pages;
  BookStatus? status = BookStatus.reading;
  DateTime? startDate;
  DateTime? finishDate;
  int progress = 0;

  Book({
    required this.title,
    required this.author,
    required this.pages,
    this.status,
    this.startDate,
    this.finishDate,
    this.progress = 0,
  });

  void setStartDate(DateTime startDate) {
    //TODO("Add better date validation");
    if(status != BookStatus.reading && status != BookStatus.finished) {
      return;
    }
    if(status == BookStatus.finished && startDate.isAfter(finishDate!)) {
      return;
    }
    this.startDate = startDate;
  }

  void setFinishDate(DateTime finishDate) {
    if(status != BookStatus.finished) {
      return;
    }
    if(startDate != null && finishDate.isBefore(startDate!)) {
      throw Exception('Finish date cannot be before start date');
    }
    this.finishDate = finishDate;
  }

  void setStatus(BookStatus status) {
    this.status = status;
    if(status == BookStatus.finished && finishDate == null) {
      finishDate = startDate ?? DateTime.now();
    } else if(status == BookStatus.reading && startDate == null) {
      startDate = DateTime.now();
    }else if (finishDate != null && startDate != null && finishDate!.isBefore(startDate!)) {
      finishDate = startDate;
    }
  }

  @override
  String toString() {
    return 'Book{\ntitle: $title, \nauthor: $author, \npages: $pages, '
    '\nstatus: $status\nstartDate: $startDate, \nfinishDate: $finishDate\n}';
  }

  static Book addBookInit() {
    var book = Book(title: '', author: '', pages: 0);
    book.setStatus(BookStatus.reading);
    return book;
  }
}

enum BookStatus {
  reading,
  finished,
  wantToRead;

  @override
  String toString(){
    switch(this){
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
