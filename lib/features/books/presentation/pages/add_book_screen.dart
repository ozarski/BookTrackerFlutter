import 'package:book_tracker/core/services/router.dart';
import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/domain/entities/book.dart';
import 'package:book_tracker/features/books/domain/usecases/add_book.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/state/new_book_model.dart';
import 'package:book_tracker/features/books/presentation/widgets/add_book_date_pickers.dart';
import 'package:book_tracker/features/books/presentation/widgets/status_selection_radio_buttons.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addBookUseCase = context.read<AddBookUseCase>();
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController pagesController = TextEditingController();

    return ChangeNotifierProvider(
      create: (context) =>
          ModifyBookStateModel(addBookUseCase, Book.addBookInit()),
      child: Consumer<ModifyBookStateModel>(
        builder: (context, newBookModel, child) {
          titleController.text = newBookModel.getTitle();
          authorController.text = newBookModel.getAuthor();
          pagesController.text = newBookModel.getNumberOfPages().toString();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Book',
                  style: TextStyle(fontWeight: FontWeight.w300)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    var connection = await Connectivity().checkConnectivity();
                    if (connection.contains(ConnectivityResult.wifi) ||
                        connection.contains(ConnectivityResult.mobile) ||
                        connection.contains(ConnectivityResult.ethernet) ||
                        connection.contains(ConnectivityResult.bluetooth)) {
                      if (context.mounted) {
                        Navigator.pushNamed(context, RouteGenerator.search,
                            arguments: {
                              'bookModel': newBookModel,
                            });
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'No internet connection',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                  },
                ).addPadding(const EdgeInsets.only(right: 10)),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                splashColor: const Color.fromARGB(60, 70, 70, 70),
                onPressed: () async {
                  if (await newBookModel.saveToDatabase()) {
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
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w300)),
              ),
            ),
            body: Center(
              child: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextField(
                        controller: titleController,
                        cursorColor: Colors.white,
                        decoration: textFieldDecoration('title'),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (title) {
                          newBookModel.setTitle(title);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextField(
                        controller: authorController,
                        cursorColor: Colors.white,
                        decoration: textFieldDecoration('author'),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (author) {
                          newBookModel.setAuthor(author);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextField(
                        controller: pagesController,
                        cursorColor: Colors.white,
                        decoration: textFieldDecoration('pages'),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (numberOfPages) {
                          if (numberOfPages != "") {
                            newBookModel
                                .setNumberOfPages(int.parse(numberOfPages));
                          }
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
            ),
          );
        },
      ),
    );
  }

  InputDecoration textFieldDecoration(String labelText) {
    return InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      labelText: labelText,
    );
  }
}
