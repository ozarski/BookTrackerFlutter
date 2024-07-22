import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({super.key, required Book book}) : _book = book;

  final Book _book;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          _book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
        ),
        subtitle: Text(
          _book.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w300, color: Color.fromARGB(255, 45, 45, 45)),
        ),
        //trailing: const Icon(Icons.info_outline),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        onTap: () {
          Navigator.pushNamed(context, '/book_details', arguments: {
            'book': _book,
          });
        },
      ),
    );
  }
}
