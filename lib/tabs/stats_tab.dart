import 'package:book_tracker/providers/book_list_model.dart';
import 'package:book_tracker/widgets/stat_widget.dart';
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
          var totalBooks = model.books.length;
          var pagesPerbook = totalBooks == 0 ? 0 : totalPages / totalBooks;
          //TODO("replace placeholders with actual values")
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              StatWidget(
                title: "total pages",
                value: totalPages.toString(),
                fontSize: 40.0,
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatWidget(
                          title: "total books", value: totalBooks.toString()),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                      const StatWidget(title: "pages per day", value: "42"),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                      const StatWidget(title: "books per month", value: "2.4"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatWidget(
                          title: "pages per book",
                          value: pagesPerbook.toStringAsFixed(2)),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                      const StatWidget(title: "days per book", value: "12.7"),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                      const StatWidget(title: "books per week", value: "0.6"),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
