import 'package:flutter/material.dart';
import 'package:three_chess/helpers/sqflite_helper.dart';

enum ChessColor {
  Purple,
  Purple700,
  Orange,
  Red,
  Blue,
  Blue700,
  Grey,
  Black,
  White
}

class ChessTheme {
  static ThemeData theme = ThemeData(
    // appBarTheme: appBarTheme,
    primaryTextTheme: textTheme,
    // iconTheme: iconTheme,
    colorScheme: colorScheme,
    // dividerTheme: dividerTheme,
    // inputDecorationTheme: inputDecoration,
    // snackBarTheme: snackBarTheme,
    // sliderTheme: sliderTheme,
  );

  static Map<ChessColor, Color> colorInterface = {
    ChessColor.Purple: Colors.purple,
    ChessColor.Purple700: Colors.purple[700],
    ChessColor.Orange: Colors.orange,
    ChessColor.Red: Colors.red,
    ChessColor.Blue: Colors.blue,
    ChessColor.Blue700: Colors.blue[700],
    ChessColor.Grey: Colors.grey,
    ChessColor.Black: Colors.black,
    ChessColor.White: Colors.white,
  };

  // static SliderThemeData sliderTheme = SliderThemeData();
  // static Map<String, String> sliderThemeData = {};

  // static SnackBarThemeData snackBarTheme = SnackBarThemeData();
  // static Map<String, String> snackBarThemeData = {};

  // static DividerThemeData dividerTheme = DividerThemeData();
  // static Map<String, String> dividerSchemeData = {};

  // static IconThemeData iconTheme = IconThemeData();
  // static Map<String, String> iconThemeData = {};

  // static AppBarTheme appBarTheme = AppBarTheme();
  // static Map<String, String> appBarThemeData = {};

  static InputDecorationTheme inputDecoration = InputDecorationTheme(
    // Border
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(
          color: colorInterface[ChessColor
              .values[inputDecorationThemeData['disabledBorder']['color']]],
          style: BorderStyle
              .values[inputDecorationThemeData['disabledBorder'][' style']],
          width:
              inputDecorationThemeData['disabledBorder']['width'].toDouble() ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(
          color: colorInterface[ChessColor
              .values[inputDecorationThemeData['errorBorder']['color']]],
          style: BorderStyle
              .values[inputDecorationThemeData['errorBorder']['style']],
          width: inputDecorationThemeData['errorBorder']['width'].toDouble()),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(
          color: colorInterface[ChessColor
              .values[inputDecorationThemeData['enabledBorder']['color']]],
          style: BorderStyle
              .values[inputDecorationThemeData['enabledBorder']['style']],
          width: inputDecorationThemeData['enabledBorder']['width'].toDouble()),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(
          color: colorInterface[ChessColor
              .values[inputDecorationThemeData['focusedBorder']['color']]],
          style: BorderStyle
              .values[inputDecorationThemeData['focusedBorder']['style']],
          width: inputDecorationThemeData['focusedBorder']['width'].toDouble()),
    ),
    // Color
    fillColor: colorScheme.surface,
    hoverColor: colorScheme.primaryVariant,
    focusColor: colorScheme.primary,
    // padding
    contentPadding: EdgeInsets.all(4),
  );

  static Map<String, Map<String, int>> inputDecorationThemeData = {
    'disabledBorder': {
      'color': textThemeData['bodyText1']['color'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
    'enabledBorder': {
      'color': colorSchemeData['primaryVariant'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
    'errorBorder': {
      'color': colorSchemeData['error'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
    'focusBorder': {
      'color': colorSchemeData['primary'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
  };

  static TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      color: colorInterface[
          ChessColor.values[textThemeData['headline1']['color']]],
      fontSize: textThemeData['headline1']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['headline1']['fontWeight']],
    ),
    headline2: TextStyle(
      color: colorInterface[
          ChessColor.values[textThemeData['headline2']['color']]],
      fontSize: textThemeData['headline2']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['headline2']['fontWeight']],
    ),
    caption: TextStyle(
      color:
          colorInterface[ChessColor.values[textThemeData['caption']['color']]],
      fontSize: textThemeData['caption']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['caption']['fontWeight']],
    ),
    subtitle1: TextStyle(
      color: colorInterface[
          ChessColor.values[textThemeData['subtitle1']['color']]],
      fontSize: textThemeData['subtitle1']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['subtitle1']['fontWeight']],
    ),
    subtitle2: TextStyle(
      color: colorInterface[
          ChessColor.values[textThemeData['subtitle2']['color']]],
      fontSize: textThemeData['subtitle2']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['subtitle2']['fontWeight']],
    ),
    bodyText1: TextStyle(
      color: colorInterface[
          ChessColor.values[textThemeData['bodyText1']['color']]],
      fontSize: textThemeData['bodyText1']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['bodyText1']['fontWeight']],
    ),
    bodyText2: TextStyle(
      color: colorInterface[
          ChessColor.values[textThemeData['bodyText2']['color']]],
      fontSize: textThemeData['bodyText2']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['bodyText2']['fontWeight']],
    ),
    overline: TextStyle(
      color:
          colorInterface[ChessColor.values[textThemeData['overline']['color']]],
      fontSize: textThemeData['overline']['fontSize'].toDouble(),
      fontWeight: FontWeight.values[textThemeData['overline']['fontWeight']],
    ),
  );

  static Map<String, Map<String, int>> textThemeData = lightTextThemeData;

  static Map<String, Map<String, int>> lightTextThemeData = {
    'headline1': {
      'color': ChessColor.Black.index,
      'fontSize': 25,
      'fontWeight': FontWeight.bold.index,
    },
    'headline2': {
      'color': ChessColor.Black.index,
      'fontSize': 21,
      'fontWeight': FontWeight.w800.index,
    },
    'caption': {
      'color': ChessColor.Black.index,
      'fontSize': 19,
      'fontWeight': FontWeight.w600.index,
    },
    'subtitle1': {
      'color': ChessColor.Black.index,
      'fontSize': 18,
      'fontWeight': FontWeight.normal.index,
    },
    'subtitle2': {
      'color': ChessColor.Black.index,
      'fontSize': 18,
      'fontWeight': FontWeight.w800.index,
    },
    'bodyText1': {
      'color': ChessColor.Black.index,
      'fontSize': 14,
      'fontWeight': FontWeight.normal.index,
    },
    'bodyText2': {
      'color': ChessColor.Black.index,
      'fontSize': 13,
      'fontWeight': FontWeight.w500.index,
    },
    'overline': {
      'color': ChessColor.Black.index,
      'fontSize': 6,
      'fontWeight': FontWeight.normal.index,
    },
  };
  static Map<String, Map<String, int>> darkTextThemeData = {
    'headline1': {
      'color': ChessColor.White.index,
      'fontSize': 25,
      'fontWeight': FontWeight.bold.index,
    },
    'headline2': {
      'color': ChessColor.White.index,
      'fontSize': 21,
      'fontWeight': FontWeight.w800.index,
    },
    'caption': {
      'color': ChessColor.White.index,
      'fontSize': 19,
      'fontWeight': FontWeight.w600.index,
    },
    'subtitle1': {
      'color': ChessColor.White.index,
      'fontSize': 18,
      'fontWeight': FontWeight.normal.index,
    },
    'subtitle2': {
      'color': ChessColor.White.index,
      'fontSize': 18,
      'fontWeight': FontWeight.w800.index,
    },
    'bodyText1': {
      'color': ChessColor.White.index,
      'fontSize': 14,
      'fontWeight': FontWeight.normal.index,
    },
    'bodyText2': {
      'color': ChessColor.White.index,
      'fontSize': 13,
      'fontWeight': FontWeight.w500.index,
    },
    'overline': {
      'color': ChessColor.White.index,
      'fontSize': 6,
      'fontWeight': FontWeight.normal.index,
    },
  };
  static ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.values[colorSchemeData['brightness']],
    onPrimary: colorInterface[
        colorSchemeData['onPrimary']], // TextColor when written on primary
    onError: colorInterface[colorSchemeData['onError']],
    onBackground: colorInterface[colorSchemeData['onBackground']],
    onSecondary: colorInterface[colorSchemeData['onSecondary']],
    onSurface: colorInterface[colorSchemeData['onSurface']],
    primaryVariant: colorInterface[colorSchemeData['primaryVariant']],
    background: colorInterface[colorSchemeData['background']],
    error: colorInterface[colorSchemeData['error']],
    primary: colorInterface[colorSchemeData['primary']],
    secondary: colorInterface[colorSchemeData['secondary']],
    secondaryVariant: colorInterface[colorSchemeData['secondaryVariant']],
    surface: colorInterface[colorSchemeData['surface']],
  );

// Light Color Theme with Black writing
  static Map<String, int> colorSchemeData = lightColorScheme;

  static Map<String, int> lightColorScheme = {
    'brightness': Brightness.light.index,
    'onPrimary': ChessColor.White.index, // Text on Primary
    'onError': ChessColor.White.index,
    'onBackground': ChessColor.Black.index,
    'onSecondary': ChessColor.White.index,
    'onSurface': ChessColor.Black.index,
    'primaryVariant': ChessColor.Purple700.index,
    'background': ChessColor.White.index,
    'error': ChessColor.Red.index,
    'primary': ChessColor.Purple.index,
    'secondary': ChessColor.Blue.index,
    'secondaryVariant': ChessColor.Blue700.index,
    'surface': ChessColor.White.index,
  };

  static Map<String, int> darkColorScheme = {
    'brightness': Brightness.dark.index,
    'onPrimary': ChessColor.White.index, // Text on Primary
    'onError': ChessColor.White.index,
    'onBackground': ChessColor.White.index,
    'onSecondary': ChessColor.White.index,
    'onSurface': ChessColor.White.index,
    'primaryVariant': ChessColor.Purple700.index,
    'background': ChessColor.Black.index,
    'error': ChessColor.Red.index,
    'primary': ChessColor.Purple.index,
    'secondary': ChessColor.Blue.index,
    'secondaryVariant': ChessColor.Blue700.index,
    'surface': ChessColor.Black.index,
  };
}
