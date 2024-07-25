import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GoogleBooksApiService {
  final String baseUrl = 'https://www.googleapis.com/books/v1/volumes'
  '';
  final Dio dio;

  GoogleBooksApiService(this.dio);

  Future<Map<String, dynamic>> searchBooks(String keywords) async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (kDebugMode) {
            print(error.message);
          }
          return handler.next(error);
        },
      )
    );
    final response = await dio.get(
      baseUrl,
      queryParameters: {
        'q': keywords.split(' ').join('+'),
        'fields': 'items(volumeInfo(title, authors, imageLinks(thumbnail), pageCount))',
        'maxResults': 10,
      },
    );

    return response.data;
  }

}