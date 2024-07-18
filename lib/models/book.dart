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

  @override
  String toString() {
    return 'Book{title: $title, author: $author, pages: $pages, status: $status}';
  }
}

enum BookStatus {
  reading,
  finished,
  wantToRead,
}