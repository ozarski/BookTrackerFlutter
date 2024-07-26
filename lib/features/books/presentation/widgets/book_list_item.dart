import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({super.key, required Book book}) : _book = book;

  final Book _book;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 0.5),
        ),
        elevation: 3,
        color: Colors.white,
        child: ListTile(
          title: Text(
            _book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w300, color: Colors.black),
          ),
          subtitle: Text(
            _book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 45, 45, 45)),
          ),
          leading: Builder(builder: (context) {
            if(_book.thumbnail.isNotEmpty){
              return Image.network(_book.thumbnail, width: 50, height: 50,);
            }
            else{
              return const Icon(Icons.book, size: 50,);
            }
          },),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          onTap: () {
            Navigator.pushNamed(context, '/book_details', arguments: {
              'bookID': _book.id,
            });
          },
        ),
      ),
    );
  }
}
