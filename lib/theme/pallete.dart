import 'package:flutter/material.dart';

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static const lightWhiteColor = Color.fromRGBO(255, 255, 255, 0.5);
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
      titleTextStyle: TextStyle(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: whiteColor,
      textColor: whiteColor,
    ),
    //rounded textfield theme data for dark mode
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: greyColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
    primaryColor: redColor,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: drawerColor,
    ), // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: blackColor,
      textColor: blackColor,
    ),
    //rounded textfield theme data for light mode
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: lightWhiteColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    colorScheme: ColorScheme.fromSwatch(backgroundColor: whiteColor),
  );
}
