import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/state/book_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookProgressSlider extends StatefulWidget {
  const BookProgressSlider({super.key, required this.listModel});
  final BookListModel listModel;

  @override
  State<BookProgressSlider> createState() => _BookProgressSliderState();
}

class _BookProgressSliderState extends State<BookProgressSlider> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookStateModel>(
      builder: (context, bookModel, child) {
        if (bookModel.book == null) return Container();
        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 0.5,
              ),
              child: Slider(
                value: bookModel.book!.progress.toDouble(),
                min: 0,
                max: bookModel.book!.pages.toDouble(),
                onChanged: (value) {
                  setState(() {
                    bookModel.updateProgress(value.toInt());
                  });
                },
                onChangeEnd: (value) {
                  bookModel.saveProgress(value.toInt());
                  widget.listModel.updateBook(bookModel.book!);
                },
                label: bookModel.book!.progress.toString(),
                thumbColor: Colors.black,
                activeColor: Colors.black,
                inactiveColor: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
