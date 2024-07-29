import 'dart:io';

import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/core/data_sources/book_database_constants.dart';
import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
                      icon: const Icon(Icons.settings),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text(
                                  'Settings',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                children: [
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _exportDatabase(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        child: const Text(
                                          'Export database',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          _importDatabase(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        child: const Text(
                                          'Import database',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ).addPadding(const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5)),
                                ],
                              );
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

  void _exportDatabase(BuildContext context) async {
    var database =
        await Provider.of<BookDatabase>(context, listen: false).database;
    var databaseFile = File(database.path);

    String? outputDirectory = await FilePicker.platform.getDirectoryPath();

    if (outputDirectory != null) {
      databaseFile
          .copy('$outputDirectory/${BookDatabaseConstants.databaseName}');
    }
  }

  void _importDatabase(BuildContext context) async {
    var database =
        await Provider.of<BookDatabase>(context, listen: false).database;
    var databaseFile = File(database.path);

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      await file.copy(databaseFile.path);
      try {
        if (context.mounted) {
          final bookListModel = context.read<BookListModel>();
          final statsModel = context.read<StatsStateModel>();
          bookListModel.reloadBooks();
          statsModel.reloadStats();
        }
      } catch (e) {
        kDebugMode ? print(e) : null;
      }
    }
  }
}
