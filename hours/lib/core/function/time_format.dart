String timeFormat(DateTime dateTime) {
  return "${dateTime.hour.toString().padLeft(2, "0")}:${dateTime.minute.toString().padLeft(2, "0")}";
}
