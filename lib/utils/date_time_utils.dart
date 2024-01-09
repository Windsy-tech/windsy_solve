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