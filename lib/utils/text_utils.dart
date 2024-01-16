extension TextUtils on String {
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text
        .split(' ')
        .map((str) => str[0].toUpperCase() + str.substring(1))
        .join(' ');
  }
}
