Duration differnceTime(DateTime start, DateTime end) {
  if (start.year != 2015 && end.year != 2015) {
    return DateTime(end.year, end.month, end.day, end.hour, end.minute)
        .difference(DateTime(
            start.year, start.month, start.day, start.hour, start.minute));
  } else {
    return const Duration();
  }
}
