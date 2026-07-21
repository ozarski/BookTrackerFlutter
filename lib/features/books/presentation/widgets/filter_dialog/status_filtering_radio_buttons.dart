import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusFilteringRadioButtons extends StatelessWidget {
  const StatusFilteringRadioButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterStateModel>(
      builder: (context, filterStateModel, child) {
        return Column(
          children: [
            statusRadioButton(null, 'All', filterStateModel),
            statusRadioButton(
                BookStatus.reading, 'Reading', filterStateModel),
            statusRadioButton(
                BookStatus.finished, 'Finished', filterStateModel),
            statusRadioButton(
                BookStatus.wantToRead, 'Want to read', filterStateModel),
          ],
        ).addPadding(
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        );
      },
    );
  }

  Widget statusRadioButton(BookStatus? targetStatus, String label,
      FilterStateModel filterStateModel) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        filterStateModel.setStatus(targetStatus);
      },
      child: Theme(
        data: ThemeData.dark(),
        child: Row(
          children: [
            Radio<BookStatus?>(
              value: targetStatus,
              groupValue: filterStateModel.status,
              onChanged: (value) {
                filterStateModel.setStatus(value);
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
