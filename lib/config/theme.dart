import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSizes {
  static const double fieldRadius = 16;
  static const int splashScreenTitleFontSize = 48;
  static const int titleFontSize = 34;
  static const double sidePadding = 15;
  static const double widgetSidePadding = 20;
  static const double buttonRadius = 25;
  static const double imageRadius = 8;
  static const double linePadding = 4;
  static const double widgetBorderRadius = 34;
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
  static const lightTurquoise = Color(0xFFB9DCEE);
  static const pink = Color(0xFFF6C9DF);
}

final themeData = ThemeData(
  useMaterial3: true,
  primaryColor: AppColors.red,
  highlightColor: AppColors.black,
  primaryColorLight: AppColors.lightGray,
  textTheme: GoogleFonts.robotoTextTheme()
      .copyWith(
        displayLarge: const TextStyle(
            fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        displayMedium: const TextStyle(
            fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        displaySmall:
            const TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
        headlineMedium: const TextStyle(
            fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        headlineSmall:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleLarge: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        titleMedium: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        titleSmall: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyLarge: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelLarge: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        labelSmall: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      )
      .apply(
        displayColor: AppColors.black,
        bodyColor: AppColors.black,
      ),
  dialogBackgroundColor: AppColors.backgroundLight,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
      borderSide: const BorderSide(
        color: AppColors.red,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
      borderSide: const BorderSide(
        color: AppColors.error,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
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

      return AppColors.black;
    }),
    suffixIconColor:
        MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.error)) {
        return AppColors.error;
      }

      if (states.contains(MaterialState.focused)) {
        return AppColors.red;
      }

      return AppColors.black;
    }),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.red,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.lightGray),
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
    backgroundColor: AppColors.backgroundLight,
    accentColor: AppColors.red,
  ).copyWith(
    onBackground: AppColors.black,
    error: AppColors.error,
    onError: AppColors.white,
    onPrimary: AppColors.white,
    onSecondary: AppColors.lightTurquoise,
    onSurface: AppColors.black,
    primary: AppColors.red,
    secondary: AppColors.lightTurquoise,
    surface: AppColors.white,
  ),
  dividerColor: AppColors.transparent,
  appBarTheme: const AppBarTheme(
      color: AppColors.white,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      toolbarTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      )),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.red,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
    ),
    minWidth: 50,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      return AppColors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.red.withOpacity(0.5);
      }
      return AppColors.lightGray;
    }),
  ),
);
