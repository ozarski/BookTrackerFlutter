class Book {
  String title;
  String author;
  int pages;
  BookStatus status = BookStatus.reading;
  

  Book({
    required this.title,
    required this.author,
    required this.pages,
  });
}

enum BookStatus {
  reading,
  finished,
  wantToRead,
}