import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/presentation/state/new_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusSelectionRadioButtons extends StatefulWidget {
  const StatusSelectionRadioButtons({super.key});

  @override
  State<StatusSelectionRadioButtons> createState() =>
      StatusSelectionRadioButtonsState();
}

class StatusSelectionRadioButtonsState
    extends State<StatusSelectionRadioButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 10),
      child: Consumer<ModifyBookStateModel>(
        builder: (context, newBookModel, child) {
          BookStatus? status = newBookModel.book.status;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              statusRadioButton(
                newBookModel,
                status,
                BookStatus.reading,
                'Reading',
              ),
              statusRadioButton(
                newBookModel,
                status,
                BookStatus.finished,
                'Finished',
              ),
              statusRadioButton(
                newBookModel,
                status,
                BookStatus.wantToRead,
                'Want to read',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget statusRadioButton(ModifyBookStateModel book, BookStatus? status,
      BookStatus targetStatus, String label) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() => status = targetStatus);
        book.setStatus(targetStatus);
      },
      child: Theme(
        data: ThemeData.dark(),
        child: Row(
          children: [
            Radio<BookStatus>(
              value: targetStatus,
              groupValue: status,
              onChanged: (status) {
                setState(() => status = status);
                book.setStatus(status!);
              },
              activeColor: Colors.white,
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
