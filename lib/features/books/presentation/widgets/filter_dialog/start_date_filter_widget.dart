import 'package:book_tracker/features/books/presentation/state/filter_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartDateFilterWidget extends StatelessWidget {
  const StartDateFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final filterModel = context.watch<FilterStateModel>();
    return InkWell(
      onTap: () async {
        DateTime? date = await setUpDatePicker(filterModel, context);
        if (date != null) {
          filterModel.setStartDate(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            const Spacer(),
            Text(
              filterModel.getFormattedStartDate(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> setUpDatePicker(
      FilterStateModel filterModel, BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: filterModel.startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: filterModel.finishDate ?? DateTime(2101),
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
