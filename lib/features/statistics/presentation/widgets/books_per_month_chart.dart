
import 'package:book_tracker/core/utils/padding_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BooksPerMonthChart extends StatefulWidget {
  const BooksPerMonthChart({super.key, required this.booksPerMonth});

  final Map<int, int> booksPerMonth;

  @override
  State<BooksPerMonthChart> createState() => _BooksPerMonthChartState();
}

class _BooksPerMonthChartState extends State<BooksPerMonthChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) =>
                Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.round().toString(),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        barGroups: _getBarGroups(widget.booksPerMonth),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 2 != 0) {
                    return const SizedBox();
                  }
                  return Text(
                    monthIntToString(value.toInt()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            )),
        gridData: const FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    ).addPadding(
      const EdgeInsets.all(20),
    );
  }

  List<BarChartGroupData> _getBarGroups(Map<int, int> booksPerMonth) {
    final List<BarChartGroupData> barGroups = [];
    booksPerMonth.forEach((month, bookCount) {
      final barGroup = BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(
            toY: bookCount.toDouble(),
            width: 12,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          )
        ],
      );
      barGroups.add(barGroup);
    });
    return barGroups;
  }

  String monthIntToString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
