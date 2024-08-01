import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var searchQuery = '';
    return SimpleDialog(
      title: Text(
        'Search for books',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.primary),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by title or author',
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                  ).addPadding(
                    const EdgeInsets.only(left: 15),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final model = context.read<BookListModel>();
                    model.searchBooks(searchQuery);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ).addPadding(const EdgeInsets.all(20)),
      ],
    );
  }
}
