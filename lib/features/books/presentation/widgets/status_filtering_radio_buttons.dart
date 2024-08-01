import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusFilteringRadioButtons extends StatefulWidget {
  const StatusFilteringRadioButtons({super.key});

  BookStatus get status => BookStatus.reading;

  @override
  State<StatusFilteringRadioButtons> createState() =>
      _StatusFilteringRadioButtonsState();
}

class _StatusFilteringRadioButtonsState
    extends State<StatusFilteringRadioButtons> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FilterStateModel>(
      builder: (context, filterStateModel, child) {
        return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statusRadioButton(BookStatus.reading, 'Reading', filterStateModel),
        statusRadioButton(BookStatus.finished, 'Finished', filterStateModel),
        statusRadioButton(BookStatus.wantToRead, 'Want to read', filterStateModel),
      ],
    ).addPadding(
      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    ); },
    );
  }

  Widget statusRadioButton(
      BookStatus targetStatus, String label, FilterStateModel filterStateModel) {

    BookStatus status = filterStateModel.status;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() => status = targetStatus);
        filterStateModel.status = targetStatus;
      },
      child: Theme(
        data: ThemeData.dark(),
        child: Row(
          children: [
            Radio<BookStatus>(
              value: targetStatus,
              groupValue: status,
              onChanged: (value) {
                setState(() => status = value ?? BookStatus.reading);
                filterStateModel.status = targetStatus;
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
