import 'package:book_tracker/add_book_screen/status_selection_radio_buttons.dart';
import 'package:book_tracker/book.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = '';
    String author = '';
    String pages = '';
    BookStatus? status;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 300,
        child: FloatingActionButton(
          onPressed: () {
            print('Title: $title');
            print('Author: $author');
            print('Pages: $pages');
            print('Status: $status');
          },
          child: const Text('SAVE', style: TextStyle(fontSize: 20)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  author = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Pages',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  pages = value;
                },
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: StatusSelectionRadioButtons(
              onStatusSelected: (value) {
                status = value;
              },
            )),
          ],
        ),
      ),
    );
  }
}