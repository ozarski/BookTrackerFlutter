import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/widgets/filter_dialog/filter_dialog.dart';
import 'package:book_tracker/features/books/presentation/widgets/search_dialog.dart';
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
                appBar: appBar(context, model),
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

  PreferredSizeWidget appBar(BuildContext context, BookListModel model) {
    return AppBar(
      title: const Text('Your books',
          style: TextStyle(fontWeight: FontWeight.w300)),
      scrolledUnderElevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
        ),
      ),
      actions: [
        searchIconButton(context, model),
        filterIconButton(context),
        settingsIconButton(context),
      ],
    );
  }

  Widget searchIconButton(BuildContext context, BookListModel model) {
    return IconButton(
      icon: Icon(model.searching ? Icons.search_off : Icons.search),
      onPressed: () {
        if (model.searching) {
          model.reloadBooks();
          model.searching = false;
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const SearchDialog();
            },
          );
        }
      },
    );
  }

  Widget filterIconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list_alt),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const FilterDialog();
          },
        );
      },
    );
  }

  Widget settingsIconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return const SettingsDialog();
          },
        );
      },
    );
  }
}
