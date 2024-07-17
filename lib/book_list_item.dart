import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({super.key, required String title, required String author})
      : _title = title,
        _author = author;

  final String _title;
  final String _author;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(_title),
        subtitle: Text(_author),
        trailing: const Icon(Icons.info_outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        tileColor: const Color(0xFFE0E0E0),
      ),
    );
  }
}
