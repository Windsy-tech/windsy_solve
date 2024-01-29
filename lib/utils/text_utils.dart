extension TextUtils on String {
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text
        .split(' ')
        .map((str) => str[0].toUpperCase() + str.substring(1))
        .join(' ');
  }

  String shortenFileName(int maxLength) {
    if (length <= maxLength) {
      return this;
    }

    String extension = split('.').last;
    String truncatedName = substring(0, maxLength - extension.length - 1);

    return '$truncatedName...$extension';
  }
}
