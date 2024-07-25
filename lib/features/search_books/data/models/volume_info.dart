import 'package:book_tracker/features/search_books/data/models/image_links.dart';
import 'package:book_tracker/features/search_books/domain/entities/google_books_volume.dart';

class VolumeInfo {
  String title;
  List<String> authors;
  int pageCount;
  ImageLinks? imageLinks;

  VolumeInfo({
    required this.title,
    required this.authors,
    required this.pageCount,
    this.imageLinks,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
      title: json['title'],
      authors: List<String>.from(json['authors']),
      pageCount: json['pageCount'],
      imageLinks: json['imageLinks'] != null ? ImageLinks.fromJson(json['imageLinks']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authors': authors,
      'pageCount': pageCount,
      'imageLinks': imageLinks?.toJson(),
    };
  }

  GoogleBooksVolume toEntity(){
    return GoogleBooksVolume(
      title: title,
      authors: authors.join(', '),
      thumbnail: imageLinks?.thumbnail ?? '',
      pageCount: pageCount,
    );
  }
}