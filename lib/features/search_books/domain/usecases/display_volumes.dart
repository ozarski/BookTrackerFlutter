import 'package:book_tracker/core/use_case.dart';
import 'package:book_tracker/features/search_books/data/repositories/google_books_repository.dart';
import 'package:book_tracker/features/search_books/domain/entities/google_books_volume.dart';

class DisplayVolumesUseCase implements UseCase<List<GoogleBooksVolume>, String>{
  final GoogleBooksRepository repository;

  DisplayVolumesUseCase(this.repository);

  @override
  Future<List<GoogleBooksVolume>> call(String query) async {
    var volumesInfo = await repository.searchBooks(query);
    return volumesInfo.map((volumeInfo) => volumeInfo.toEntity()).toList();
  }
}