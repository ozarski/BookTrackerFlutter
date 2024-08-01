import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:book_tracker/features/statistics/presentation/widgets/books_per_month_chart.dart';
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
            return SingleChildScrollView(
              child: Column(
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
                      booksPerMonth(context, statsModel),
                      pagesPerDay(context, statsModel),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      booksPerYear(context, statsModel),
                      booksPerWeek(context, statsModel)
                    ],
                  ),
                  Row(
                    children: [
                      booksToBeRead(context, statsModel),
                    ],
                  ),
                  Row(
                    children: [
                      booksReadThisYear(context, statsModel),
                      bookReadThisMonth(context, statsModel),
                    ],
                  ),
                  Row(
                    children: [
                      booksPerMonthThisYearBarChart(context, statsModel),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget totalBooks(BuildContext context, StatsStateModel statsModel) {
    return Expanded(
      child: statContainer(
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
      ),
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
          const Text('pages per book',
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
    return Expanded(
      child: statContainer(
        Column(
          children: [
            const Text('days per book',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Text(statsModel.stats['days per book'] ?? '0',
                style: const TextStyle(color: Colors.white, fontSize: 19)),
          ],
        ).addPadding(const EdgeInsets.all(20)),
        context,
        Theme.of(context).colorScheme.tertiary,
      ).addPadding(
        const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 10),
      ),
    );
  }

  Widget pagesPerDay(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(statsModel.stats['pages per day'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 23)),
          const SizedBox(
            width: 70,
            child: Text(
              'pages per day',
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
      const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 10),
    );
  }

  Widget booksPerMonth(BuildContext context, StatsStateModel statsModel) {
    return Expanded(
      child: statContainer(
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 90,
              child: Text(
                'books per month',
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
        const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 20),
      ),
    );
  }

  Widget booksPerWeek(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Column(
        children: [
          const Text('books per week',
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
    return Expanded(
      child: statContainer(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 80,
              child: Text(
                'books per year',
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
      ),
    );
  }

  Widget booksToBeRead(BuildContext context, StatsStateModel statsModel) {
    return Expanded(
      child: statContainer(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(statsModel.stats['books to be read this year'] ?? '0',
                style: const TextStyle(color: Colors.white, fontSize: 23)),
            const SizedBox(
              width: 250,
              child: Text(
                'books will be read this year with current pace',
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ).addPadding(const EdgeInsets.all(20)),
        context,
        const Color.fromARGB(116, 252, 230, 108),
      ).addPadding(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget booksReadThisYear(BuildContext context, StatsStateModel statsModel) {
    return statContainer(
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 100,
            child: Text(
              'books read this year',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ).addPadding(const EdgeInsets.only(right: 20)),
          Text(statsModel.stats['books read this year'] ?? '0',
              style: const TextStyle(color: Colors.white, fontSize: 23)),
        ],
      ).addPadding(const EdgeInsets.all(20)),
      context,
      Theme.of(context).colorScheme.tertiary,
    ).addPadding(
      const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 20),
    );
  }

  Widget bookReadThisMonth(BuildContext context, StatsStateModel statsModel) {
    return Expanded(
      child: statContainer(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(statsModel.stats['books read this month'] ?? '0',
                style: const TextStyle(color: Colors.white, fontSize: 23)),
            const SizedBox(
              width: 100,
              child: Text(
                'books read this month',
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.right,
              ),
            ).addPadding(const EdgeInsets.only(right: 10)),
          ],
        ).addPadding(const EdgeInsets.all(20)),
        context,
        const Color.fromARGB(116, 252, 230, 108),
      ).addPadding(
        const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 10),
      ),
    );
  }

  Widget booksPerMonthThisYearBarChart(
      BuildContext context, StatsStateModel statsModel) {
    return Expanded(
      child: statContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Books read each month this year',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(
              height: 300,
              child:
                  BooksPerMonthChart(booksPerMonth: statsModel.booksPerMonth),
            ),
          ],
        ).addPadding(const EdgeInsets.all(20)),
        context,
        Theme.of(context).colorScheme.tertiary,
      ).addPadding(
        const EdgeInsets.only(top: 10, bottom: 30, right: 20, left: 20),
      ),
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
}
