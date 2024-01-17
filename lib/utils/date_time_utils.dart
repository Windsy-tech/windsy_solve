class DateTimeUtils {
  static String getFormattedDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String getFormattedTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}';
  }

  static String getFormattedDateTime(DateTime dateTime) {
    return '${getFormattedDate(dateTime)} ${getFormattedTime(dateTime)}';
  }
}

extension DateTimeExtension on DateTime {
  String toDateString() {
    return '$day/$month/$year';
  }

  String toTimeString() {
    return '$hour:$minute';
  }

  String toDateTimeString() {
    return '${toDateString()} ${toTimeString()}';
  }
}
