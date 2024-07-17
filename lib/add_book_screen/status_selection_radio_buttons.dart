import 'package:book_tracker/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatusSelectionRadioButtons extends StatefulWidget {
  const StatusSelectionRadioButtons({super.key, required this.onStatusSelected});

  final Function(BookStatus?) onStatusSelected;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => setState(() => _status = BookStatus.reading),
            child: Row(
              children: [
                Radio<BookStatus>(
                  value: BookStatus.reading,
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() => _status = value);
                    widget.onStatusSelected(value);
                  }
                ),
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
            onTap: () => setState(() => _status = BookStatus.finished),
            child: Row(
              children: [
                Radio<BookStatus>(
                  value: BookStatus.finished,
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() => _status = value);
                    widget.onStatusSelected(value);
                  }
                ),
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
            onTap: () => setState(() => _status = BookStatus.wantToRead),
            child: Row(
              children: [
                Radio<BookStatus>(
                  value: BookStatus.wantToRead,
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() => _status = value);
                    widget.onStatusSelected(value);
                  }
                ),
                const Text(
                  'Want to read',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
