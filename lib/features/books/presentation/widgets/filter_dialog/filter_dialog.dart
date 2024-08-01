import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/books/presentation/state/book_list_model.dart';
import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';
import 'package:book_tracker/features/books/presentation/widgets/filter_dialog/finish_date_filter_widget.dart';
import 'package:book_tracker/features/books/presentation/widgets/filter_dialog/start_date_filter_widget.dart';
import 'package:book_tracker/features/books/presentation/widgets/filter_dialog/status_filtering_radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FilterStateModel>(
      create: (context) => FilterStateModel(),
      child: Consumer<FilterStateModel>(
        builder: (context, filterStateModel, child) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.only(right: 10, top: 20),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    'by status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ).addPadding(const EdgeInsets.only(top: 10)),
                  const StatusFilteringRadioButtons(),
                  const Text(
                    'by date',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ).addPadding(const EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Consumer<FilterStateModel>(
                        builder: (context, filterModel, child) {
                          return Expanded(
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StartDateFilterWidget(),
                                FinishDateFilterWidget(),
                              ],
                            ).addPadding(
                                const EdgeInsets.only(top: 10, bottom: 20)),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final bookListState = context.read<BookListModel>();
                          bookListState.filterList(filterStateModel);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final bookListState = context.read<BookListModel>();
                          bookListState.reloadBooks();
                          filterStateModel.reset();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      )
                    ],
                  ).addPadding(const EdgeInsets.symmetric(vertical: 10))
                ],
              ).addPadding(
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ],
          );
        },
      ),
    );
  }
}
