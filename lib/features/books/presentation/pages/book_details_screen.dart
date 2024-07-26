import 'package:book_tracker/core/utils/global_functions.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/usecases/delete_book.dart';
import 'package:book_tracker/features/books/domain/usecases/display_book_details.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_progress.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book_status.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/state/book_state_model.dart';
import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/widgets/book_progress_slider.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    int bookID = routeArgs['bookID'] as int;
    final DisplayBookDetailsUseCase displayBookDetailsUseCase =
        context.read<DisplayBookDetailsUseCase>();
    final UpdateBookProgressUseCase updateBookProgressUseCase =
        context.read<UpdateBookProgressUseCase>();
    final UpdateBookStatusUseCase updateBookStatusUseCase =
        context.read<UpdateBookStatusUseCase>();
    final DeleteBookUseCase deleteBookUseCase =
        context.read<DeleteBookUseCase>();

    return ChangeNotifierProvider(
      create: (context) => BookStateModel(
        displayBookDetailsUseCase: displayBookDetailsUseCase,
        updateBookProgressUseCase: updateBookProgressUseCase,
        updateBookStatusUseCase: updateBookStatusUseCase,
        deleteBookUseCase: deleteBookUseCase,
        id: bookID,
      ),
      child: Consumer<BookStateModel>(
        builder: (context, bookModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Book Details',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: Divider(
                  color: Colors.black,
                  height: 4.0,
                  thickness: 0.5,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit_book',
                      arguments: {'book': bookModel.book},
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    if (await deleteBook(context, bookModel)) {
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red)
                      .addPadding(const EdgeInsets.only(right: 10)),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          if (bookModel.getThumbnail().isNotEmpty) {
                            return Image.network(
                              bookModel.getThumbnail(),
                              width: 200,
                              height: 200,
                            );
                          } else {
                            return const Icon(
                              Icons.book,
                              size: 200,
                            );
                          }
                        },
                      ).addPadding(const EdgeInsets.only(top: 20)),
                      basicBookInfo(bookModel),
                      Builder(
                        builder: (context) {
                          if (bookModel.getBookStatus() ==
                              BookStatus.finished) {
                            return finishedBookDetails(bookModel);
                          } else if (bookModel.getBookStatus() ==
                              BookStatus.reading) {
                            return readingBookDetails(bookModel);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      bottomActionButtons(bookModel, context)
                          .addPadding(const EdgeInsets.only(bottom: 20)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bottomActionButtons(BookStateModel bookModel, BuildContext context) {
    return Builder(
      builder: (context) {
        if (bookModel.getBookStatus() == BookStatus.reading) {
          return changeStatusButton('Finish', context, bookModel, () {
            bookModel.setStatus(BookStatus.finished);
            final statsModel = context.read<StatsStateModel>();
            statsModel.reloadStats();
          });
        } else if (bookModel.getBookStatus() == BookStatus.wantToRead) {
          return changeStatusButton('Start reading', context, bookModel, () {
            bookModel.setStatus(BookStatus.reading);
          });
        }
        return Container();
      },
    );
  }

  Widget basicBookInfo(BookStateModel bookModel) {
    return Column(
      children: [
        Text(
          bookModel.getBookTitle(),
          style: const TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ).addPadding(
          const EdgeInsets.only(
            top: 10,
            bottom: 5,
            left: 20,
            right: 20,
          ),
        ),
        Text(
          'by ${bookModel.getBookAuthor()}',
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ).addPadding(const EdgeInsets.only(bottom: 20)),
        const Divider(
          color: Colors.black,
          thickness: 0.5,
          indent: 20,
          endIndent: 20,
        ),
        Text(bookModel.getBookPages().toString(),
                style: const TextStyle(fontSize: 20))
            .addPadding(const EdgeInsets.only(top: 20)),
        const Text('number of pages'),
      ],
    );
  }

  Widget bookDates(BookStateModel bookModel) {
    return Column(
      children: [
        Text(bookModel.getFormattedStartDate(),
                style: const TextStyle(fontSize: 20))
            .addPadding(const EdgeInsets.only(top: 20)),
        const Text('start date'),
        Text(bookModel.getFormattedFinishDate(),
                style: const TextStyle(fontSize: 20))
            .addPadding(const EdgeInsets.only(top: 20)),
        const Text('finish date'),
      ],
    );
  }

  Widget finishedBookDetails(BookStateModel bookModel) {
    // +1 because the start date is included in the reading time
    int readingTime = daysBetweenDates(
            bookModel.getStartDate()!, bookModel.getFinishDate()!) +
        1;

    double bookPagesPerDay = bookModel.getBookPages() / readingTime;
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

  Widget readingBookDetails(BookStateModel bookModel) {
    return Column(children: [
      Text(bookModel.getFormattedStartDate(),
              style: const TextStyle(fontSize: 20))
          .addPadding(const EdgeInsets.only(top: 20)),
      const Text('start date'),
      bookProgress(bookModel),
      Text(bookModel.getEstimatedReadingTime(),
              style: const TextStyle(fontSize: 20))
          .addPadding(const EdgeInsets.only(top: 10)),
      const Text('estimated time left'),
    ]);
  }

  Widget bookProgress(BookStateModel bookModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('pages read'),
            Text(
              bookModel.getBookProgress().toString(),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ).addPadding(const EdgeInsets.only(top: 40)),
        const BookProgressSlider(),
      ],
    );
  }

  Widget changeStatusButton(String label, BuildContext context,
      BookStateModel bookModel, Function onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.black, width: 0.3),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ).addPadding(const EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  Future<bool> deleteBook(
      BuildContext context, BookStateModel bookModel) async {
    var deleted = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete book'),
          content: const Text('Are you sure?', style: TextStyle(fontSize: 17)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bookModel.deleteBook();
                final bookListModel = context.read<BookListModel>();
                bookListModel.reloadBooks();
                final statsModel = context.read<StatsStateModel>();
                statsModel.reloadStats();
                Navigator.of(context).pop();
                deleted = true;
              },
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.black, width: 0.5),
          ),
        );
      },
    );
    return deleted;
  }
}
