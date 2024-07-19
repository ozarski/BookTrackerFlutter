import 'package:book_tracker/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({super.key, required Book book}) : _book = book;

  final Book _book;

  @override
  Widget build(BuildContext context) {
    Color color = () {
      switch (_book.status) {
        case BookStatus.reading:
          return const Color.fromARGB(180, 108, 163, 110);
        case BookStatus.finished:
          return const Color.fromARGB(180, 108, 150, 184);
        default:
          return const Color.fromARGB(180, 181, 110, 110);
      }
    }();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          _book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _book.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
