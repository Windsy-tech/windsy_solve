import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windsy_solve/theme/theme_data.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.dark})
      : _mode = mode,
        super(
          AppTheme.lightTheme(),
        ) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = AppTheme.lightTheme();
    } else {
      _mode = ThemeMode.dark;
      state = AppTheme.darkTheme();
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('theme'));
    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = AppTheme.lightTheme();
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = AppTheme.darkTheme();
      prefs.setString('theme', 'dark');
    }
  }
}
