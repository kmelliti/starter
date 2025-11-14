import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/utils.dart';

// Text styles using Cairo font
TextStyle _cairoTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? letterSpacing,
  double? height,
}) {
  return GoogleFonts.cairo(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

class AppTheme {
  // Colors
  static final String textFieldBorder = "#CDCCE0";
  static final String textFieldSelectedBorder = "#8A899F";
  static final String primaryColor = "#2A2767";
  static final String secondaryColor = "#928FD0";
  static final String borderGrey = "#C4C4C4";
  static final String borderGreyLight = "#F0F0F0";
  static final String filledBox = "#F8F8FF";
  static final String filledBox2 = "#E8E5E5";
  static final String hintColor = "#B3B3B3";
  static final String appBackGroundColor = "#FBFBFB";
  static final String darkGrey = "#7F7F7F";
  static final String hintColor2 = "#717088";


  // Text Styles
  static TextStyle get displayLarge =>
      _cairoTextStyle(fontSize: 32, fontWeight: FontWeight.bold);

  static TextStyle get displayMedium =>
      _cairoTextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle get titleLarge =>
      _cairoTextStyle(fontSize: 22, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge =>
      _cairoTextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get bodyMedium =>
      _cairoTextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  // Button Styles
  static ButtonStyle get filledButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: HexColor.fromHex(primaryColor),
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 50),
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    textStyle: _cairoTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  static ButtonStyle get outlinedButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: HexColor.fromHex(primaryColor),
    minimumSize: const Size(double.infinity, 50),
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    side: BorderSide(color: HexColor.fromHex(primaryColor), width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    textStyle: _cairoTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: HexColor.fromHex(appBackGroundColor),
    useMaterial3: false,
    fontFamily: GoogleFonts.cairo().fontFamily,
    textTheme: GoogleFonts.cairoTextTheme(
      ThemeData.light().textTheme.copyWith(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        titleLarge: titleLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: HexColor.fromHex(primaryColor),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
            color: HexColor.fromHex("#B3B3B3"),
            fontWeight: FontWeight.w600,
            fontSize: 12
        )
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: HexColor.fromHex(textFieldBorder)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: HexColor.fromHex(textFieldSelectedBorder),
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: TextStyle(
          color: HexColor.fromHex("#B3B3B3"),
          fontWeight: FontWeight.w600,
          fontSize: 14
      ),
      errorStyle: const TextStyle(color: Colors.red),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: filledButtonStyle),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,

    textTheme: GoogleFonts.cairoTextTheme(
      ThemeData.dark().textTheme.copyWith(
        displayLarge: displayLarge.copyWith(color: Colors.white),
        displayMedium: displayMedium.copyWith(color: Colors.white),
        titleLarge: titleLarge.copyWith(color: Colors.white),
        bodyLarge: bodyLarge.copyWith(color: Colors.white70),
        bodyMedium: bodyMedium.copyWith(color: Colors.white70),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: HexColor.fromHex(primaryColor),
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: HexColor.fromHex(textFieldBorder)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey[500]),
      errorStyle: const TextStyle(color: Colors.red),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue[300],
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  );

  Widget custume(Widget child) {
    return Container(decoration: BoxDecoration(), child: child);
  }
}

// Extension for easy theme access
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
