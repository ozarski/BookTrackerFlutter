import 'package:dio/dio.dart';

class GoogleBooksApiService {
  final String baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  final Dio dio;
  final String apiKey;

  GoogleBooksApiService(this.dio, {required this.apiKey});

  Future<Map<String, dynamic>> searchBooks(String keywords) async {
    var attempt = 0;
    while (true) {
      try {
        final response = await dio.get(
          baseUrl,
          queryParameters: {
            'q': 'intitle:"${keywords.replaceAll('"', '')}"',
            'fields': 'items(volumeInfo(title, authors, imageLinks(thumbnail), pageCount))',
            'maxResults': 10,
            'key': apiKey,
          },
        );
        return response.data;
      } on DioException catch (e) {
        attempt++;
        if (e.response?.statusCode == 503 && attempt < 3) {
          await Future.delayed(Duration(seconds: attempt));
          continue;
        }
        rethrow;
      }
    }
  }
}