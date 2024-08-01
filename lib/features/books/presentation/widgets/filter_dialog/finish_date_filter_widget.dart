import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinishDateFilterWidget extends StatelessWidget {
  const FinishDateFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final filterModel = context.watch<FilterStateModel>();
    return InkWell(
      child: Text(
        filterModel.getFormattedFinishDate(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 17,
        ),
      ),
      onTap: () async {
        DateTime? date = await setUpDatePicker(filterModel, context);
        if (date != null) {
          filterModel.setFinishDate(date);
        }
      },
    );
  }

  Future<DateTime?> setUpDatePicker(
      FilterStateModel filterModel, BuildContext context) async {
        var initialDate = DateTime.now();
        if(filterModel.startDate != null && filterModel.finishDate != null && filterModel.finishDate!.isBefore(filterModel.startDate!)){
          initialDate = filterModel.startDate!;
        }
        else{
          initialDate = filterModel.finishDate ?? filterModel.startDate ?? DateTime.now();
        }
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: filterModel.startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return datePickerTheme(child!, context);
      },
    );
  }

  Theme datePickerTheme(Widget child, BuildContext context) {
    return Theme(
        data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.black,
              surface: Theme.of(context).colorScheme.secondary,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.secondary,
            scaffoldBackgroundColor: Theme.of(context).colorScheme.secondary,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )),
        child: child);
  }
}
