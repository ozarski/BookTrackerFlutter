import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/statistics/presentation/widgets/stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<BookListModel>(
        builder: (context, model, child) {
          var totalPages = model.books.fold(
              0, (previousValue, element) => previousValue + element.pages);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatWidget(
                title: "total pages",
                value: totalPages.toString(),
                fontSize: 40.0,
              ).addPadding(const EdgeInsets.symmetric(vertical: 50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  statsLeftColumn(model),
                  statsRightColumn(model),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  //TODO("replace placeholders with actual values")
  Widget statsLeftColumn(BookListModel bookListModel) {
    var totalBooks = bookListModel.books.length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatWidget(title: "total books", value: totalBooks.toString())
            .addPadding(const EdgeInsets.only(bottom: 25)),
        const StatWidget(title: "pages per day", value: "42")
            .addPadding(const EdgeInsets.only(bottom: 25)),
        const StatWidget(title: "books per month", value: "2.4")
            .addPadding(const EdgeInsets.only(bottom: 25)),
      ],
    );
  }

  Widget statsRightColumn(BookListModel bookListModel) {
    var totalBooks = bookListModel.books.length;
    var totalPages = bookListModel.books
        .fold(0, (previousValue, element) => previousValue + element.pages);
    var pagesPerbook = totalBooks == 0 ? 0 : totalPages / totalBooks;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatWidget(
                title: "pages per book", value: pagesPerbook.toStringAsFixed(2))
            .addPadding(const EdgeInsets.only(bottom: 25)),
        const StatWidget(title: "days per book", value: "12.7")
            .addPadding(const EdgeInsets.only(bottom: 25)),
        const StatWidget(title: "books per week", value: "0.6")
            .addPadding(const EdgeInsets.only(bottom: 25)),
      ],
    );
  }
}
