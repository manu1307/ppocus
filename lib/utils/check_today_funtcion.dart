bool checkToday(year, month, day) {
  DateTime todayDate = DateTime.now();

  if (year == todayDate.year &&
      month == todayDate.month &&
      day == todayDate.day) {
    return true;
  }
  return false;
}
