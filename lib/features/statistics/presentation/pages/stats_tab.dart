import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:book_tracker/features/statistics/presentation/state/stats_model.dart';
import 'package:book_tracker/features/statistics/presentation/widgets/stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  //TODO("replace placeholders with actual values")
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<StatsStateModel>(
        builder: (context, statsModel, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatWidget(
                title: "total pages",
                value: statsModel.stats['total pages'] ?? '0',
                fontSize: 40.0,
              ).addPadding(const EdgeInsets.symmetric(vertical: 50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  statsLeftColumn(statsModel),
                  statsRightColumn(statsModel),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget statsLeftColumn(StatsStateModel statsModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatWidget(title: "total books", value: statsModel.stats['total books'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(title: "pages per day", value: statsModel.stats['pages per day'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(title: "books per month", value: statsModel.stats['books per month'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
      ],
    );
  }

   Widget statsRightColumn(StatsStateModel statsModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatWidget(title: "pages per book", value: statsModel.stats['pages per book'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(title: "days per book", value: statsModel.stats['days per book'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
        StatWidget(title: "books per week", value: statsModel.stats['books per week'] ?? '0')
            .addPadding(const EdgeInsets.only(bottom: 25)),
      ],
    );
  }
}
