import 'package:flutter/services.dart';

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

  String shortenText() {
    if (length <= 30) {
      return this;
    }

    return '${substring(0, 30)}...';
  }
}

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any spaces from the entered text
    if (newValue.text.contains(' ')) {
      String newText = newValue.text.replaceAll(' ', '');
      int offset = newText.length;
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
      );
    }
    return newValue;
  }
}
