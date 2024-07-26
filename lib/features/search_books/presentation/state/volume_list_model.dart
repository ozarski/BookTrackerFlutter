import 'package:book_tracker/features/search_books/domain/entities/google_books_volume.dart';
import 'package:book_tracker/features/search_books/domain/usecases/display_volumes.dart';
import 'package:flutter/material.dart';

class VolumeListModel extends ChangeNotifier{
  List<GoogleBooksVolume> _volumes = [];
  List<GoogleBooksVolume> get volumes => _volumes;

  final DisplayVolumesUseCase _displayVolumesUseCase;

  VolumeListModel(this._displayVolumesUseCase);

  void loadVolumes(String query) async {
    _volumes = await _displayVolumesUseCase(query);
    notifyListeners();
  }
}