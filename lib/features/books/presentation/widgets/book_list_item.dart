import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/core/widgets/book_cover_image.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({super.key, required Book book}) : _book = book;

  final Book _book;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          color: Theme.of(context).colorScheme.tertiary,
          child: content(context),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/book_details',
            arguments: {
              'bookID': _book.id,
            },
          );
        },
      ),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                if (_book.thumbnail.isNotEmpty) {
                  return SizedBox(
                    width: 100,
                    height: 150,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: BookCoverImage(
                        url: _book.thumbnail,
                        noConnectionIcon: Container(
                          width: 100,
                          height: 150,
                          alignment: Alignment.center,
                          child: const Icon(Icons.book, size: 100),
                        ).addPadding(const EdgeInsets.only(left: 10, top: 10)),
                      ),
                    ),
                  ).addPadding(const EdgeInsets.only(left: 10, top: 10));
                } else {
                  return Container(
                    width: 100,
                    height: 150,
                    alignment: Alignment.center,
                    child: const Icon(Icons.book, size: 100),
                  ).addPadding(const EdgeInsets.only(left: 10, top: 10));
                }
              },
            ),
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _book.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 27,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    "by ${_book.author}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ).addPadding(const EdgeInsets.only(right: 20, top: 10)),
          ],
        ),
        Builder(
          builder: (context) {
            if (_book.status == BookStatus.reading) {
              return LinearProgressIndicator(
                value: _book.progress / _book.pages,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
                minHeight: 20,
                borderRadius: BorderRadius.circular(10),
              ).addPadding(const EdgeInsets.all(10));
            } else if (_book.status == BookStatus.finished) {
              return LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
                minHeight: 20,
                borderRadius: BorderRadius.circular(10),
              ).addPadding(const EdgeInsets.all(10));
            } else {
              return Container();
            }
          },
        ).addPadding(const EdgeInsets.only(top: 5, bottom: 5)),
      ],
    );
  }
}
