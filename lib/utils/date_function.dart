Map<String, dynamic> dateProcess(DateTime rawDate) {
  int year = rawDate.year;
  int month = rawDate.month;
  int day = rawDate.day;
  DateTime date = DateTime(year, month, day);

  return {
    "year": year,
    "month": month,
    "day": day,
    "date": date,
  };
}
