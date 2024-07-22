import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/presentation/state/new_book_model.dart';
import 'package:book_tracker/core/utils/PaddingExtension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StartDatePickerWidget extends StatelessWidget {
  const StartDatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewBookStateModel>(
      builder: (context, newBookModel, child) {
        DateTime date = newBookModel.book.startDate ?? DateTime.now();
        var formattedDate = DateFormat('dd.MM.yyyy').format(date);

        return InkWell(
            onTap: () async {
              DateTime? pickedDate = await setUpDatePicker(newBookModel, context);
              if (pickedDate != null) {
                newBookModel.setStartDate(pickedDate);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Start date:", style: TextStyle(fontSize: 20)),
                Text(formattedDate, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ).addPadding(const EdgeInsets.symmetric(horizontal: 20, vertical: 10));
      },
    );
  }

  Future<DateTime?> setUpDatePicker(
      NewBookStateModel bookModel, BuildContext context) async {
    if (bookModel.book.status == BookStatus.reading) {
      return await showDatePicker(
        context: context,
        initialDate: bookModel.book.startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
    } else if (bookModel.book.status == BookStatus.finished) {
      return await showDatePicker(
        context: context,
        initialDate: bookModel.book.startDate,
        firstDate: DateTime(2000),
        lastDate: bookModel.book.finishDate ?? DateTime(2101),
      );
    }
    return null;
  }
}
