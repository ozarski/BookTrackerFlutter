import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/widgets/filter_dialog.dart';
import 'package:book_tracker/features/books/presentation/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import '../widgets/book_list_item.dart';
import 'package:provider/provider.dart';

class BookListTab extends StatelessWidget {
  const BookListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Consumer<BookListModel>(
            builder: (context, model, child) {
              return Scaffold(
                backgroundColor: const Color(0xFF1F1E22),
                appBar: AppBar(
                  title: const Text('Your books',
                      style: TextStyle(fontWeight: FontWeight.w300)),
                  scrolledUnderElevation: 0.0,
                  backgroundColor: const Color(0xFFFCE76C),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.filter_list_alt),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const FilterDialog();
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const SettingsDialog();
                            });
                      },
                    ),
                  ],
                ),
                body: ListView.builder(
                  itemCount: model.books.length,
                  itemBuilder: (context, index) {
                    return BookListItem(book: model.books[index]);
                  },
                ).addPadding(const EdgeInsets.only(top: 10)),
              );
            },
          ),
        ),
      ],
    );
  }
}
