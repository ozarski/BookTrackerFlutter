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
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    var connection = await Connectivity().checkConnectivity();
                    if (connection.contains(ConnectivityResult.wifi) ||
                        connection.contains(ConnectivityResult.mobile)||
                        connection.contains(ConnectivityResult.ethernet)||
                        connection.contains(ConnectivityResult.bluetooth)) {
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/search', arguments: {
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
                child: const Text('Save',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w300)),
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
                      controller: titleController,
                      cursorColor: Colors.black,
                      decoration: textFieldDecoration('title'),
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
                      cursorColor: Colors.black,
                      decoration: textFieldDecoration('author'),
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
                      cursorColor: Colors.black,
                      decoration: textFieldDecoration('pages'),
                      keyboardType: TextInputType.number,
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
          );
        },
      ),
    );
  }

  InputDecoration textFieldDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
    );
  }
}
