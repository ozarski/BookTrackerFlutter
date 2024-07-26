import 'package:book_tracker/features/search_books/data/models/volume_info.dart';

abstract class GoogleBooksRepositoryInterface {
  Future<List<VolumeInfo>> searchBooks(String query);
}
