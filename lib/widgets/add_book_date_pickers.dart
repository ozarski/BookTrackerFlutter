import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/new_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBookDates extends StatefulWidget {
  const NewBookDates({super.key});

  @override
  State<NewBookDates> createState() => _NewBookDatesState();
}

class _NewBookDatesState extends State<NewBookDates> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewBookModel>(
      builder: (context, newBookModel, child) {
        if (newBookModel.book.status == BookStatus.reading) {
          return const Text('Reading');
        } else if (newBookModel.book.status == BookStatus.finished) {
          return const Text('Finished');
        }
        return const Text('Want to read');
      },
    );
  }
}
