import 'package:book_tracker/providers/new_book_model.dart';
import 'package:book_tracker/widgets/add_book_date_pickers.dart';
import 'package:book_tracker/widgets/status_selection_radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewBookModel(),
      child: Consumer<NewBookModel>(
        builder: (context, newBookModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Book'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: 300,
              child: FloatingActionButton(
                onPressed: () {
                  //TODO("Save the book to the database");
                  print(newBookModel.book);
                },
                child: const Text('SAVE', style: TextStyle(fontSize: 20)),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (title) {
                        newBookModel.setTitle(title);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Author',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (author) {
                        newBookModel.setAuthor(author);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Pages',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (numberOfPages) {
                        newBookModel.setNumberOfPages(int.parse(numberOfPages));
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: StatusSelectionRadioButtons(),
                  ),
                  const NewBookDates(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
