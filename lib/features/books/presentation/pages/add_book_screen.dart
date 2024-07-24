import 'package:book_tracker/features/books/domain/usecases/add_book.dart';
import 'package:book_tracker/features/books/presentation/state/new_book_model.dart';
import 'package:book_tracker/features/books/presentation/widgets/add_book_date_pickers.dart';
import 'package:book_tracker/features/books/presentation/widgets/status_selection_radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addBookUseCase = context.read<AddBookUseCase>();
    return ChangeNotifierProvider(
      create: (context) => NewBookStateModel(addBookUseCase),
      child: Consumer<NewBookStateModel>(
        builder: (context, newBookModel, child) {
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Book', style: TextStyle(fontWeight: FontWeight.w300)),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: Divider(
                  color: Colors.black,
                  height: 4.0,
                  thickness: 0.5,
                  indent: 0.0,
                  endIndent: 0.0,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FloatingActionButton(
                onPressed: () async {
                  if(await newBookModel.saveToDatabase()){
                    if(context.mounted) Navigator.pop(context);
                  }
                  else {
                    Fluttertoast.showToast(
                        msg: 'Please fill in all fields',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                },
                child: const Text('SAVE',
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
