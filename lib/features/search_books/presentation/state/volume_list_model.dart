import 'dart:io';

import 'package:book_tracker/features/search_books/domain/entities/google_books_volume.dart';
import 'package:book_tracker/features/search_books/domain/usecases/display_volumes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class VolumeListModel extends ChangeNotifier {
  List<GoogleBooksVolume> _volumes = [];
  List<GoogleBooksVolume> get volumes => _volumes;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final DisplayVolumesUseCase _displayVolumesUseCase;

  VolumeListModel(this._displayVolumesUseCase);

  void loadVolumes(String query) async {
    _errorMessage = null;
    try {
      _volumes = await _displayVolumesUseCase(query);
      if (_volumes.isEmpty) {
        _errorMessage = 'No results found.';
      }
    } on DioException catch (e) {
      _volumes = [];
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Connection timed out. Try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        _errorMessage = 'No internet connection.';
      } else if (e.response?.statusCode == 403) {
        _errorMessage = 'API key error. Check your Google Books API key.';
      } else if (e.response?.statusCode == 429) {
        _errorMessage = 'Rate limit exceeded. Try again later.';
      } else if (e.response?.statusCode == 503) {
        _errorMessage = 'Google Books API temporarily unavailable (503). Try again.';
      } else {
        _errorMessage = 'Search failed (${e.response?.statusCode ?? "error"}).';
      }
    } on SocketException {
      _volumes = [];
      _errorMessage = 'No internet connection.';
    } catch (e) {
      _volumes = [];
      _errorMessage = 'Something went wrong.';
    }
    notifyListeners();
  }
}