
int daysBetweenDates(DateTime startDate, DateTime finishDate) {
  startDate = DateTime(startDate.year, startDate.month, startDate.day);
  finishDate = DateTime(finishDate.year, finishDate.month, finishDate.day);

  return (finishDate.difference(startDate).inHours / 24).round();
}