import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/new_book_model.dart';
import 'package:book_tracker/widgets/finish_date_picker_widget.dart';
import 'package:book_tracker/widgets/start_date_picker_widget.dart';
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
          return const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StartDatePickerWidget(),
            ],
          );
        } else if (newBookModel.book.status == BookStatus.finished) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StartDatePickerWidget(),
              FinishDatePickerWidget(),
            ],
          );
        }
        return Container();
      },
    );
  }
}
