import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/new_book_model.dart';
import 'package:book_tracker/utils/PaddingExtension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FinishDatePickerWidget extends StatelessWidget {
  const FinishDatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewBookModel>(
      builder: (context, newBookModel, child) {
        DateTime date = newBookModel.book.finishDate ??
            newBookModel.book.startDate ??
            DateTime.now();
        var formattedDate = DateFormat('dd.MM.yyyy').format(date);

        return InkWell(
          onTap: () async {
            DateTime? pickedDate = await setUpDatePicker(newBookModel, context);
            if (pickedDate != null) {
              newBookModel.setFinishDate(pickedDate);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Finish date:", style: TextStyle(fontSize: 20)),
              Text(formattedDate, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ).addPadding(const EdgeInsets.symmetric(horizontal: 20, vertical: 10));
      },
    );
  }

  Future<DateTime?> setUpDatePicker(
      NewBookModel bookModel, BuildContext context) async {
    if (bookModel.book.status == BookStatus.finished) {
      return await showDatePicker(
        context: context,
        initialDate: bookModel.book.finishDate,
        firstDate: bookModel.book.startDate ?? DateTime.now(),
        lastDate: DateTime(2101),
      );
    }
    return null;
  }
}
