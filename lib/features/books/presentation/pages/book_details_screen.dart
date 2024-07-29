import 'package:book_tracker/core/utils/global_functions.dart';
import 'package:book_tracker/core/widgets/book_cover_image.dart';
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            appBar: AppBar(
              title: const Text(
                'Book Details',
                style: TextStyle(fontWeight: FontWeight.w300),
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
            body: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            bookCoverImage(bookModel),
                            basicBookInfo(bookModel, context),
                          ],
                        ),
                      ),
                      numberOfPages(bookModel),
                      Builder(
                        builder: (context) {
                          if (bookModel.getBookStatus() ==
                              BookStatus.finished) {
                            return finishedBookDetails(bookModel);
                          } else if (bookModel.getBookStatus() ==
                              BookStatus.reading) {
                            return readingBookDetails(bookModel, context);
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

  Widget basicBookInfo(BookStateModel bookModel, BuildContext context) {
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
      ],
    );
  }

  Widget numberOfPages(BookStateModel bookModel) {
    return Column(
      children: [
        Text(bookModel.getBookPages().toString(),
                style: const TextStyle(fontSize: 20, color: Colors.black))
            .addPadding(const EdgeInsets.only(top: 20)),
        const Text('number of pages', style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget bookDates(BookStateModel bookModel) {
    return Column(
      children: [
        Text(
          bookModel.getFormattedStartDate(),
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ).addPadding(const EdgeInsets.only(top: 20)),
        const Text('start date', style: TextStyle(color: Colors.black)),
        Text(
          bookModel.getFormattedFinishDate(),
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ).addPadding(const EdgeInsets.only(top: 20)),
        const Text('finish date', style: TextStyle(color: Colors.black)),
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
        Text(
          bookPagesPerDay.toStringAsFixed(2),
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ).addPadding(const EdgeInsets.only(top: 20)),
        const Text('pages per day', style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget readingBookDetails(BookStateModel bookModel, BuildContext context) {
    return Column(children: [
      Text(
        bookModel.getFormattedStartDate(),
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ).addPadding(const EdgeInsets.only(top: 20)),
      const Text('start date', style: TextStyle(color: Colors.black)),
      bookProgress(bookModel, context),
      Text(
        bookModel.getEstimatedReadingTime(),
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ).addPadding(const EdgeInsets.only(top: 10)),
      const Text('estimated time left', style: TextStyle(color: Colors.black)),
    ]);
  }

  Widget bookProgress(BookStateModel bookModel, BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('pages read', style: TextStyle(color: Colors.black)),
              Text(
                bookModel.getBookProgress().toString(),
                style: const TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ).addPadding(const EdgeInsets.only(top: 40)),
          onTap: () {
            updateProgressDialog(context, bookModel);
          },
        ),
        const BookProgressSlider(),
      ],
    );
  }

  void updateProgressDialog(BuildContext context, BookStateModel bookModel) {
    showDialog(
        context: context,
        builder: (context) {
          var controller = TextEditingController(
              text: bookModel.getBookProgress().toString());
          return AlertDialog(
            title: Text('Set pages read', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
            content: 
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pages read',
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  bookModel.updateProgress(int.parse(controller.text));
                  Navigator.of(context).pop();
                },
                child: const Text('Set'),
              ),
            ],
          );
        });
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
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
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
          title: Text('Delete book',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: const Text('Are you sure?', style: TextStyle(fontSize: 17)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          actionsPadding: const EdgeInsets.only(right: 20, bottom: 10),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: Text('Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
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

  Widget bookCoverImage(BookStateModel bookModel) {
    return Builder(
      builder: (context) {
        if (bookModel.getThumbnail().isNotEmpty) {
          return SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BookCoverImage(
                url: bookModel.getThumbnail(),
                noConnectionIcon: const Icon(Icons.book, size: 200),
              ),
            ),
          );
        } else {
          return const Icon(
            Icons.book,
            size: 200,
          );
        }
      },
    ).addPadding(
      const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
    );
  }
}
