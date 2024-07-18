import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/new_book_model.dart';
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
  BookStatus? _status = BookStatus.reading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 10),
      child: Consumer<NewBookModel>(
        builder: (context, newBookModel, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() => _status = BookStatus.reading);
                  newBookModel.setStatus(BookStatus.reading);
                },
                child: Row(
                  children: [
                    Radio<BookStatus>(
                        value: BookStatus.reading,
                        groupValue: _status,
                        onChanged: (status) {
                          setState(() => _status = status);
                          newBookModel.setStatus(status!);
                        }),
                    const Text(
                      'Reading',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() => _status = BookStatus.finished);
                  newBookModel.setStatus(BookStatus.finished);
                },
                child: Row(
                  children: [
                    Radio<BookStatus>(
                        value: BookStatus.finished,
                        groupValue: _status,
                        onChanged: (status) {
                          setState(() => _status = status);
                          newBookModel.setStatus(status!);
                        }),
                    const Text(
                      'Finished',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() => _status = BookStatus.wantToRead);
                  newBookModel.setStatus(BookStatus.wantToRead);
                },
                child: Row(
                  children: [
                    Radio<BookStatus>(
                        value: BookStatus.wantToRead,
                        groupValue: _status,
                        onChanged: (status) {
                          setState(() => _status = status);
                          newBookModel.setStatus(status!);
                        }),
                    const Text(
                      'Want to read',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
