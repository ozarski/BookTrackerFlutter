import 'package:book_tracker/features/search_books/data/data_sources/google_books_api_service.dart';
import 'package:book_tracker/features/search_books/data/models/volume_info.dart';
import 'package:book_tracker/features/search_books/domain/repositories/google_books_repository_interface.dart';

class GoogleBooksRepository implements GoogleBooksRepositoryInterface {
  final GoogleBooksApiService apiService;

  GoogleBooksRepository(this.apiService);

  @override
  Future<List<VolumeInfo>> searchBooks(String query) async {
    var bookJson = await apiService.searchBooks(query);

    List<VolumeInfo> volumes = bookJson['items']
        .map<VolumeInfo>((volume) => VolumeInfo.fromJson(volume['volumeInfo']))
        .toList();

    return volumes;
  }
}