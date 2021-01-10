import 'package:flutter/material.dart';

enum ChessColor {
  Purple,
  Purple700,
  Orange,
  Red,
  Blue,
  Blue300,
  Blue700,
  Grey,
  Black,
  Black54,
  White
}

class ChessTheme with ChangeNotifier {
  ThemeData get theme {
    // return ThemeData(primaryColor: Colors.purple);
    return ThemeData.from(
      textTheme: textTheme,
      colorScheme: colorScheme,
    );
  }

  static Map<int, Color> colorInterface = {
    ChessColor.Purple.index: Colors.purple,
    ChessColor.Purple700.index: Colors.purple[700],
    ChessColor.Orange.index: Colors.orange,
    ChessColor.Red.index: Colors.red,
    ChessColor.Blue.index: Colors.blue,
    ChessColor.Blue300.index: Colors.blue[300],
    ChessColor.Blue700.index: Colors.blue[700],
    ChessColor.Grey.index: Colors.grey,
    ChessColor.Black.index: Colors.black,
    ChessColor.Black54.index: Colors.black54,
    ChessColor.White.index: Colors.white,
  };

  InputDecorationTheme get inputDecoration {
    return InputDecorationTheme(
      // Border
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
            color: ChessTheme.colorInterface[ChessColor.values[ChessTheme
                    .inputDecorationThemeData['disabledBorder']['color']]] ??
                Colors.black,
            style: BorderStyle.values[ChessTheme
                .inputDecorationThemeData['disabledBorder'][' style']],
            width: ChessTheme.inputDecorationThemeData['disabledBorder']
                    ['width']
                .toDouble()),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
            color: ChessTheme.colorInterface[ChessColor.values[ChessTheme
                    .inputDecorationThemeData['errorBorder']['color']]] ??
                Colors.red,
            style: BorderStyle.values[
                ChessTheme.inputDecorationThemeData['errorBorder']['style']],
            width: ChessTheme.inputDecorationThemeData['errorBorder']['width']
                .toDouble()),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
            color: ChessTheme.colorInterface[ChessColor.values[ChessTheme
                    .inputDecorationThemeData['enabledBorder']['color']]] ??
                Colors.blue,
            style: BorderStyle.values[
                ChessTheme.inputDecorationThemeData['enabledBorder']['style']],
            width: ChessTheme.inputDecorationThemeData['enabledBorder']['width']
                .toDouble()),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
            color: ChessTheme.colorInterface[ChessColor.values[ChessTheme
                    .inputDecorationThemeData['focusedBorder']['color']]] ??
                Colors.purple,
            style: BorderStyle.values[
                ChessTheme.inputDecorationThemeData['focusedBorder']['style']],
            width: ChessTheme.inputDecorationThemeData['focusedBorder']['width']
                .toDouble()),
      ),
      // Color
      fillColor: colorScheme.surface,
      hoverColor: colorScheme.primaryVariant,
      focusColor: colorScheme.primary,
      // padding
      contentPadding: EdgeInsets.all(4),
    );
  }

  static Map<String, Map<String, int>> inputDecorationThemeData = {
    'disabledBorder': {
      'color': ChessTheme.textThemeData['bodyText1']['color'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
    'enabledBorder': {
      'color': ChessTheme.colorSchemeData['primaryVariant'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
    'errorBorder': {
      'color': ChessTheme.colorSchemeData['error'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
    'focusBorder': {
      'color': ChessTheme.colorSchemeData['primary'],
      'style': BorderStyle.solid.index,
      'width': 2,
    },
  };

  TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['headline1']['color']],
      fontSize: ChessTheme.textThemeData['headline1']['fontSize'].toDouble(),
      fontWeight: FontWeight
          .values[ChessTheme.textThemeData['headline1']['fontWeight']],
    ),
    headline2: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['headline2']['color']],
      fontSize: ChessTheme.textThemeData['headline2']['fontSize'].toDouble(),
      fontWeight: FontWeight
          .values[ChessTheme.textThemeData['headline2']['fontWeight']],
    ),
    caption: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['caption']['color']],
      fontSize: ChessTheme.textThemeData['caption']['fontSize'].toDouble(),
      fontWeight:
          FontWeight.values[ChessTheme.textThemeData['caption']['fontWeight']],
    ),
    subtitle1: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['subtitle1']['color']],
      fontSize: ChessTheme.textThemeData['subtitle1']['fontSize'].toDouble(),
      fontWeight: FontWeight
          .values[ChessTheme.textThemeData['subtitle1']['fontWeight']],
    ),
    subtitle2: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['subtitle2']['color']],
      fontSize: ChessTheme.textThemeData['subtitle2']['fontSize'].toDouble(),
      fontWeight: FontWeight
          .values[ChessTheme.textThemeData['subtitle2']['fontWeight']],
    ),
    bodyText1: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['bodyText1']['color']],
      fontSize: ChessTheme.textThemeData['bodyText1']['fontSize'].toDouble(),
      fontWeight: FontWeight
          .values[ChessTheme.textThemeData['bodyText1']['fontWeight']],
    ),
    bodyText2: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['bodyText2']['color']],
      fontSize: ChessTheme.textThemeData['bodyText2']['fontSize'].toDouble(),
      fontWeight: FontWeight
          .values[ChessTheme.textThemeData['bodyText2']['fontWeight']],
    ),
    overline: TextStyle(
      color: colorInterface[
          ChessTheme.textThemeData['overline']['color']],
      fontSize: ChessTheme.textThemeData['overline']['fontSize'].toDouble(),
      fontWeight:
          FontWeight.values[ChessTheme.textThemeData['overline']['fontWeight']],
    ),
  );

  static Map<String, Map<String, int>> textThemeData =
      ChessTheme.lightTextThemeData;

  static Map<String, Map<String, int>> lightTextThemeData = {
    'headline1': {
      'color': ChessColor.Black.index,
      'fontSize': 21,
      'fontWeight': FontWeight.bold.index,
    },
    'headline2': {
      'color': ChessColor.White.index,
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
      'fontWeight': FontWeight.w500.index,
    },
    'subtitle2': {
      'color': ChessColor.White.index,
      'fontSize': 18,
      'fontWeight': FontWeight.w500.index,
    },
    'bodyText1': {
      'color': ChessColor.Black.index,
      'fontSize': 14,
      'fontWeight': FontWeight.normal.index,
    },
    'bodyText2': {
      'color': ChessColor.White.index,
      'fontSize': 14,
      'fontWeight': FontWeight.normal.index,
    },
    'overline': {
      'color': ChessColor.Black.index,
      'fontSize': 8,
      'fontWeight': FontWeight.normal.index,
    },
  };
  static Map<String, Map<String, int>> darkTextThemeData = {
    'headline1': {
      'color': ChessColor.White.index,
      'fontSize': 21,
      'fontWeight': FontWeight.bold.index,
    },
    'headline2': {
      'color': ChessColor.Black.index,
      'fontSize': 21,
      'fontWeight': FontWeight.bold.index,
    },
    'caption': {
      'color': ChessColor.White.index,
      'fontSize': 19,
      'fontWeight': FontWeight.w600.index,
    },
    'subtitle1': {
      'color': ChessColor.White.index,
      'fontSize': 18,
      'fontWeight': FontWeight.w500.index,
    },
    'subtitle2': {
      'color': ChessColor.Black.index,
      'fontSize': 18,
      'fontWeight': FontWeight.w500.index,
    },
    'bodyText1': {
      'color': ChessColor.White.index,
      'fontSize': 14,
      'fontWeight': FontWeight.normal.index,
    },
    'bodyText2': {
      'color': ChessColor.Black.index,
      'fontSize': 14,
      'fontWeight': FontWeight.normal.index,
    },
    'overline': {
      'color': ChessColor.White.index,
      'fontSize': 8,
      'fontWeight': FontWeight.normal.index,
    },
  };
ColorScheme get colorScheme {
    return ColorScheme(
      brightness: Brightness.values[ChessTheme.colorSchemeData['brightness']] 
          ,
      onPrimary: ChessTheme.colorInterface[ChessTheme.colorSchemeData['onPrimary']] 
          , // TextColor when written on primary
      onError:
          ChessTheme.colorInterface[ChessTheme.colorSchemeData['onError']] ,
      onBackground:
          ChessTheme.colorInterface[ChessTheme.colorSchemeData['onBackground']] 
              ,
      onSecondary: ChessTheme.colorInterface[ChessTheme.colorSchemeData['onSecondary']] 
          ,
      onSurface: ChessTheme.colorInterface[ChessTheme.colorSchemeData['onSurface']] 
          ,
      primaryVariant:
          ChessTheme.colorInterface[ChessTheme.colorSchemeData['primaryVariant']] 
              ,
      background: ChessTheme.colorInterface[ChessTheme.colorSchemeData['background']] 
          ,
      error: ChessTheme.colorInterface[ChessTheme.colorSchemeData['error']] ,
      primary: ChessTheme.colorInterface[ChessTheme.colorSchemeData['primary']] 
          ,
      secondary: ChessTheme.colorInterface[ChessTheme.colorSchemeData['secondary']] 
          ,
      secondaryVariant:
          ChessTheme.colorInterface[ChessTheme.colorSchemeData['secondaryVariant']] 
              ,
      surface:
          ChessTheme.colorInterface[ChessTheme.colorSchemeData['surface']] ,
    );
  }
// Light Color Theme with Black writing
  static Map<String, int> colorSchemeData = ChessTheme.lightColorScheme;

  static Map<String, int> lightColorScheme = {
    'brightness': Brightness.light.index,
    'primary': ChessColor.Purple.index,
    'onPrimary': ChessColor.White.index, // Text on Primary
    'primaryVariant': ChessColor.Purple700.index,
    'secondary': ChessColor.Blue300.index,
    'onSecondary': ChessColor.White.index,
    'secondaryVariant': ChessColor.Blue700.index,
    'error': ChessColor.Red.index,
    'onError': ChessColor.White.index,
    'background': ChessColor.White.index,
    'onBackground': ChessColor.Black.index,
    'surface': ChessColor.White.index,
    'onSurface': ChessColor.Black.index,
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
    'secondary': ChessColor.Blue300.index,
    'secondaryVariant': ChessColor.Blue700.index,
    'surface': ChessColor.Black.index,
  };
}
