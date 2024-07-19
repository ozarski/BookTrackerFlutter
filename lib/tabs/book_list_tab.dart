import 'package:book_tracker/providers/book_list_model.dart';
import 'package:flutter/material.dart';
import '../widgets/book_list_item.dart';
import 'package:provider/provider.dart';

class BookListTab extends StatelessWidget {
  const BookListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Consumer<BookListModel>(
            builder: (context, model, child) {
              model.mockBooks();
              return ListView.builder(
                itemCount: model.books.length,
                itemBuilder: (context, index) {
                  return BookListItem(book: model.books[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
