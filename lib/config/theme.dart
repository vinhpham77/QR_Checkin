import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSizes {
  static const int splashScreenTitleFontSize = 48;
  static const int titleFontSize = 34;
  static const double sidePadding = 15;
  static const double widgetSidePadding = 20;
  static const double buttonRadius = 25;
  static const double imageRadius = 8;
  static const double linePadding = 4;
  static const double widgetBorderRadius = 34;
  static const double textFieldRadius = 4.0;
  static const EdgeInsets bottomSheetPadding =
  EdgeInsets.symmetric(horizontal: 16, vertical: 10);
  static const appBarSize = 56.0;
  static const appBarExpandedSize = 180.0;
  static const tileWidth = 148.0;
  static const tileHeight = 276.0;
}

class AppColors {
  static const Color error = Color(0xffd32f2f);
  static const red = Color(0xFFDF1A73);
  static const black = Color(0xFF222222);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const white = Color(0xFFFFFFFF);
  static const orange = Color(0xFFFFBA49);
  static const background = Color(0xFFE5E5E5);
  static const backgroundLight = Color(0xFFF9F9F9);
  static const transparent = Color(0x00000000);
  static const success = Color(0xFF2AA952);
  static const green = Color(0xFF2AA952);
}

final themeData = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.robotoSerifTextTheme(),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(AppColors.red.value, {
      50: AppColors.red.withOpacity(0.1),
      100: AppColors.red.withOpacity(0.2),
      200: AppColors.red.withOpacity(0.3),
      300: AppColors.red.withOpacity(0.4),
      400: AppColors.red.withOpacity(0.5),
      500: AppColors.red.withOpacity(0.6),
      600: AppColors.red.withOpacity(0.7),
      700: AppColors.red.withOpacity(0.8),
      800: AppColors.red.withOpacity(0.9),
      900: AppColors.red,
    }),
    accentColor: AppColors.red,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.red,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.error,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.error,
      ),
    ),
    prefixIconColor:
        MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.error)) {
        return AppColors.error;
      }

      if (states.contains(MaterialState.focused)) {
        return AppColors.red;
      }

      return Colors.black;
    }),
    suffixIconColor:
        MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.error)) {
        return AppColors.error;
      }

      if (states.contains(MaterialState.focused)) {
        return AppColors.red;
      }

      return Colors.black;
    }),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.red,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
  ),
);
