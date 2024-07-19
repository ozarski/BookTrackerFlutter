import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/providers/book_list_model.dart';
import 'package:book_tracker/providers/book_model.dart';
import 'package:book_tracker/utils/PaddingExtension.dart';
import 'package:book_tracker/widgets/book_progress_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    Book book = routeArgs['book'] as Book;
    return ChangeNotifierProvider(
      create: (context) => BookModel(book: book),
      child: Consumer<BookModel>(
        builder: (context, bookModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Book Details', style: TextStyle(fontWeight: FontWeight.w300)),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: Divider(
                  color: Colors.black,
                  height: 4.0,
                  thickness: 0.5,
                  indent: 0.0,
                  endIndent: 0.0,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
              builder: (context) {
                if (bookModel.book.status == BookStatus.reading) {
                  return floatingActionButton('Finish', context, bookModel, () {
                    bookModel.setStatus(BookStatus.finished);
                    Consumer<BookListModel>(
                      builder: (context, bookListModel, child) {
                        bookListModel.bookUpdated();
                        return Container();
                      },
                    );
                  });
                } else if (bookModel.book.status == BookStatus.wantToRead) {
                  return floatingActionButton(
                      'Start reading', context, bookModel, () {
                    bookModel.setStatus(BookStatus.reading);
                    Consumer<BookListModel>(
                      builder: (context, bookListModel, child) {
                        bookListModel.bookUpdated();
                        return Container();
                      },
                    );
                  });
                }
                return Container();
              },
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    bookModel.book.title,
                    style: const TextStyle(fontSize: 35),
                    textAlign: TextAlign.center,
                  ).addPadding(const EdgeInsets.only(
                    top: 40,
                    bottom: 5,
                    left: 20,
                    right: 20,
                  )),
                  Text(
                    'by ${bookModel.book.author}',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ).addPadding(const EdgeInsets.only(bottom: 20)),
                  const Divider(
                    color: Colors.black,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Text(bookModel.book.status.toString(),
                          style: const TextStyle(fontSize: 20))
                      .addPadding(const EdgeInsets.only(top: 20)),
                  const Text('status'),
                  Text(bookModel.book.pages.toString(),
                          style: const TextStyle(fontSize: 20))
                      .addPadding(const EdgeInsets.only(top: 20)),
                  const Text('number of pages'),
                  Builder(
                    builder: (context) {
                      if (bookModel.book.status == BookStatus.finished) {
                        return finishedBookDetails(bookModel);
                      } else if (bookModel.book.status == BookStatus.reading) {
                        return readingBookDetails(bookModel);
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bookDates(BookModel bookModel) {
    return Column(
      children: [
        Text(bookModel.getStartDate(), style: const TextStyle(fontSize: 20))
            .addPadding(const EdgeInsets.only(top: 20)),
        const Text('start date'),
        Text(bookModel.getFinishDate(), style: const TextStyle(fontSize: 20))
            .addPadding(const EdgeInsets.only(top: 20)),
        const Text('finish date'),
      ],
    );
  }

  Widget finishedBookDetails(BookModel bookModel) {
    double bookPagesPerDay = bookModel.book.pages /
        (bookModel.book.finishDate!
            .difference(bookModel.book.startDate!)
            .inDays);
    return Column(
      children: [
        bookDates(bookModel),
        Text(bookPagesPerDay.toStringAsFixed(2),
                style: const TextStyle(fontSize: 20))
            .addPadding(const EdgeInsets.only(top: 20)),
        const Text('pages per day'),
      ],
    );
  }

  Widget readingBookDetails(BookModel bookModel) {
    return Column(children: [
      Text(bookModel.getStartDate(), style: const TextStyle(fontSize: 20))
          .addPadding(const EdgeInsets.only(top: 20)),
      const Text('start date'),
      bookProgress(bookModel),
    ]);
  }

  Widget bookProgress(BookModel bookModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('pages read'),
            Text(
              bookModel.book.progress.toString(),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ).addPadding(const EdgeInsets.only(top: 40)),
        const BookProgressSlider()
      ],
    );
  }

  Widget floatingActionButton(String label, BuildContext context,
      BookModel bookModel, Function onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton(
        onPressed: () {
          onPressed();
        },
        child: Text(label,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
