import 'dart:io';

import 'package:book_tracker/core/data_sources/book_database.dart';
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
                appBar: AppBar(
                  title: const Text('Your books'),
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
                      icon: const Icon(Icons.settings),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: const Text('Settings'),
                                backgroundColor: Colors.white,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _exportDatabase(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: const BorderSide(
                                                color: Colors.black,
                                                width: 0.3),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        child: const Text('Export database', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          _importDatabase(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: const BorderSide(
                                                color: Colors.black,
                                                width: 0.3),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        child: const Text('Import database', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),),
                                      )
                                    ],
                                  ).addPadding(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
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
      databaseFile.copy('$outputDirectory/book_tracker.db');
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
        final bookListModel = context.read<BookListModel>();
        final statsModel = context.read<StatsStateModel>();
        bookListModel.reloadBooks();
        statsModel.reloadStats();
      } catch (e) {
        kDebugMode ? print(e) : null;
      }
    }
  }
}
