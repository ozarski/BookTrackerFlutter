import 'dart:io';

import 'package:book_tracker/core/data_sources/book_database.dart';
import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Settings',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w300,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      children: [
        Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                _exportDatabase(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Export database',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _importDatabase(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Import database',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
            )
          ],
        ).addPadding(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
      ],
    );
  }

  void _exportDatabase(BuildContext context) async {
    var database =
        await Provider.of<BookDatabase>(context, listen: false).database;
    var databaseFile = File(database.path);

    String? outputDirectory = await FilePicker.platform.getDirectoryPath();

    String dateTimeFormatted =
        DateFormat('dd-MM-yyyy-HH-mm-ss').format(DateTime.now());
    String? outputPath = outputDirectory != null
        ? '$outputDirectory/book_database_backup_$dateTimeFormatted'
        : null;

    try {
      databaseFile.copy(outputPath!);
    } catch (exception) {
      kDebugMode ? print(exception) : null;
      Fluttertoast.showToast(
        msg: 'An error occurred while exporting the database',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    }

  void _importDatabase(BuildContext context) async {
    var database =
        await Provider.of<BookDatabase>(context, listen: false).database;
    var databaseFile = File(database.path);

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      await file.copy("${databaseFile.path}.test.db");
      if (!await BookDatabase.instance
          .importDatabase("${databaseFile.path}.test.db")) {
        Fluttertoast.showToast(
          msg: 'This is not a valid database file',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      try {
        if (context.mounted) {
          final bookListModel = context.read<BookListModel>();
          final statsModel = context.read<StatsStateModel>();
          bookListModel.reloadBooks();
          statsModel.reloadStats();
        }
      } catch (e) {
        kDebugMode ? print(e) : null;
        Fluttertoast.showToast(
          msg: 'An error occurred while importing the database',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }
}