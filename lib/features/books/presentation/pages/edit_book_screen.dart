import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/usecases/update_book.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/state/new_book_model.dart';
import 'package:book_tracker/features/books/presentation/widgets/add_book_date_pickers.dart';
import 'package:book_tracker/features/books/presentation/widgets/status_selection_radio_buttons.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditBookScreen extends StatelessWidget {
  const EditBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    Book book = routeArgs['book'] as Book? ?? Book.addBookInit();
    return ChangeNotifierProvider<ModifyBookStateModel>(
      create: (context) =>
          ModifyBookStateModel(context.read<UpdateBookUseCase>(), book),
      child: Consumer<ModifyBookStateModel>(
        builder: (context, bookModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Book',
                  style: TextStyle(fontWeight: FontWeight.w300)),
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
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      decoration: textFieldDecoration('title'),
                      onChanged: (title) {
                        bookModel.setTitle(title);
                      },
                      initialValue: book.title,
                      style: const TextStyle(color: Colors.white)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      decoration: textFieldDecoration('author'),
                      onChanged: (author) {
                        bookModel.setAuthor(author);
                      },
                      initialValue: book.author,
                      style: const TextStyle(color: Colors.white)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      decoration: textFieldDecoration('pages'),
                      keyboardType: TextInputType.number,
                      onChanged: (numberOfPages) {
                        if (numberOfPages != "") {
                          bookModel.setNumberOfPages(int.parse(numberOfPages));
                        }
                      },
                      initialValue: book.pages.toString(),
                      style: const TextStyle(color: Colors.white)
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: actionButton(bookModel, context),
          );
        },
      ),
    );
  }
}

Widget actionButton(ModifyBookStateModel bookModel, BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.9,
    child: FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      splashColor: const Color.fromARGB(62, 68, 68, 68),
      onPressed: () async {
        if (await bookModel.saveToDatabase()) {
          if (context.mounted) {
            final bookListModel = context.read<BookListModel>();
            bookListModel.reloadBooks();
            final statsModel = context.read<StatsStateModel>();
            statsModel.reloadStats();
            Navigator.pop(context);
          }
        } else {
          Fluttertoast.showToast(
              msg: 'Please fill in all fields',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Text('Save',
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w300)),
    ),
  );
}

InputDecoration textFieldDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
  );
}
