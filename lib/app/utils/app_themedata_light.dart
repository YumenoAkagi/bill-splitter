import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_constants.dart';

final filledButtonThemeDataLight = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: getColorFromHex(COLOR_2),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
    ),
    minimumSize: const Size.fromHeight(
      BUTTON_MINHEIGHT, // match parent width
    ),
  ),
);

final elevatedButtonThemeDataLight = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: getColorFromHex(COLOR_2),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
    ),
    minimumSize: const Size.fromHeight(
      BUTTON_MINHEIGHT, // match parent width
    ),
  ),
);

final outlinedButtonThemeDataLight = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: getColorFromHex(COLOR_2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
    ),
    minimumSize: const Size.fromHeight(
      BUTTON_MINHEIGHT, // match parent width
    ),
  ),
);

final appBarThemeLight = AppBarTheme(
  elevation: 0,
  foregroundColor: getColorFromHex(COLOR_2),
  backgroundColor: Colors.white,
  titleTextStyle: TextStyle(
    fontFamily: MAIN_FONT,
    fontWeight: FontWeight.bold,
    fontSize: 12 * GOLDEN_RATIO,
    color: getColorFromHex(COLOR_2),
  ),
);

const textThemeLight = TextTheme(
  labelLarge: TextStyle(fontSize: 10 * GOLDEN_RATIO), // button
  titleLarge: TextStyle(fontSize: 11 * GOLDEN_RATIO),
  titleMedium: TextStyle(fontSize: 10 * GOLDEN_RATIO), // subtitle 1
  titleSmall: TextStyle(
    fontSize: 8 * GOLDEN_RATIO,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w300,
  ), // subtitle 2
);

final inputDecorationThemeLight = InputDecorationTheme(
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(TEXTFORMFIELD_BORDER_RAD),
  ),
);
