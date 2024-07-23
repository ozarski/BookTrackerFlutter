extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime? other) {
    if (other == null) return false;
    return year == other.year && month == other.month && day == other.day;
  }
}