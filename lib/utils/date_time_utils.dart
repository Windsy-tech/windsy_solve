class DateTimeUtils {
  static String getFormattedDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String getFormattedTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String toDateTimeString() {
    return '${toDateString()} ${toTimeString()}';
  }
}
