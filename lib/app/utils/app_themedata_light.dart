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
    side: BorderSide(
      color: getColorFromHex(COLOR_1),
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

final textThemeLight = TextTheme(
  labelLarge: TextStyle(
    fontSize: 10 * GOLDEN_RATIO,
    // fontWeight: FontWeight.w900,
    color: getColorFromHex(COLOR_2),
  ), // button
  labelMedium: TextStyle(
    fontSize: 10 * GOLDEN_RATIO,
    fontWeight: FontWeight.bold,
    color: getColorFromHex(COLOR_2),
  ),
  labelSmall: TextStyle(
    fontSize: 8 * GOLDEN_RATIO,
    color: getColorFromHex(COLOR_2),
  ),
  titleLarge: TextStyle(
    fontSize: 12 * GOLDEN_RATIO,
    fontWeight: FontWeight.w900,
    color: getColorFromHex(COLOR_2),
  ),
  titleMedium: TextStyle(
    fontSize: 10 * GOLDEN_RATIO,
    color: getColorFromHex(COLOR_2),
  ), // subtitle 1 - textformfield
  titleSmall: TextStyle(
    fontSize: 9 * GOLDEN_RATIO,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w300,
    color: getColorFromHex(COLOR_2),
  ), // subtitle 2
);

final inputDecorationThemeLight = InputDecorationTheme(
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(TEXTFORMFIELD_BORDER_RAD),
  ),
);
