import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:book_tracker/features/statistics/presentation/widgets/stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistics",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Theme.of(context).colorScheme.primary,
            statusBarIconBrightness: Brightness.dark),
        child: Consumer<StatsStateModel>(
          builder: (context, statsModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    totalPages(context, statsModel),
                    totalBooks(context, statsModel),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    pagesPerBook(context, statsModel),
                    daysPerBook(context, statsModel),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    pagesPerDay(context, statsModel),
                    booksPerMonth(context, statsModel),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    booksPerYear(context, statsModel),
                    booksPerWeek(context, statsModel)
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget totalBooks(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Books',
              style: TextStyle(color: Colors.white, fontSize: 35)),
          Text(statsModel.stats['total books'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 25)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      Theme.of(context).colorScheme.tertiary,
    ).addPadding(
      const EdgeInsets.only(top: 20, bottom: 10, right: 20, left: 10),
    );
  }

  Widget totalPages(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Pages',
              style: TextStyle(color: Colors.white, fontSize: 35)),
          Text(statsModel.stats['total pages'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 25)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      Theme.of(context).colorScheme.tertiary,
    ).addPadding(
        const EdgeInsets.only(top: 20, bottom: 10, right: 10, left: 20));
  }

  Widget pagesPerBook(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Column(
        children: [
          const Text('Pages per book',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(statsModel.stats['pages per book'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 19)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      const Color.fromARGB(116, 252, 230, 108),
    ).addPadding(
      const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 20),
    );
  }

  Widget daysPerBook(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Column(
        children: [
          const Text('Days per book',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(statsModel.stats['days per book'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 19)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      Theme.of(context).colorScheme.tertiary,
    ).addPadding(
      const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 10),
    );
  }

  Widget booksPerMonth(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(statsModel.stats['pages per day'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 23)),
          const SizedBox(
            width: 70,
            child: Text(
              'Pages per day',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.right,
            ),
          ).addPadding(const EdgeInsets.only(right: 10)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      const Color.fromARGB(116, 252, 230, 108),
    ).addPadding(
      const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 20),
    );
  }

  Widget pagesPerDay(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 90,
            child: Text(
              'Books per month',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ).addPadding(const EdgeInsets.only(right: 10)),
          Text(statsModel.stats['books per month'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 23)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      Theme.of(context).colorScheme.tertiary,
    ).addPadding(
      const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 10),
    );
  }

  Widget booksPerWeek(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Column(
        children: [
          const Text('Books per week',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(statsModel.stats['books per week'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 19)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      Theme.of(context).colorScheme.tertiary,
    ).addPadding(
      const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 10),
    );
  }

  Widget booksPerYear(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 80,
            child: Text(
              'Books per year',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ).addPadding(const EdgeInsets.only(right: 0)),
          Text(statsModel.stats['books per year'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 23)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      Theme.of(context).colorScheme.tertiary,
    ).addPadding(
      const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 20),
    );
  }

  Widget statContainer(
      Widget content, BuildContext context, Color containerColor) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: content,
    );
  }

  Widget statsLeftColumn(StatsStateModel statsModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatWidget(
                title: "total books",
                value: statsModel.stats['total books'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(
                title: "pages per day",
                value: statsModel.stats['pages per day'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(
                title: "books per month",
                value: statsModel.stats['books per month'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
      ],
    );
  }

  Widget statsRightColumn(StatsStateModel statsModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatWidget(
                title: "pages per book",
                value: statsModel.stats['pages per book'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(
                title: "days per book",
                value: statsModel.stats['days per book'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(
                title: "books per week",
                value: statsModel.stats['books per week'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
      ],
    );
  }
}
