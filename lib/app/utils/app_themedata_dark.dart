import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_constants.dart';

final appBarThemeDark = AppBarTheme(
  elevation: 0,
  backgroundColor: getColorFromHex(COLOR_DARK_MAIN),
  titleTextStyle: const TextStyle(
    fontFamily: MAIN_FONT,
    fontWeight: FontWeight.bold,
    fontSize: 12 * GOLDEN_RATIO,
  ),
);

final filledButtonThemeDataDark = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: getColorFromHex(COLOR_1),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
    ),
    minimumSize: const Size.fromHeight(
      BUTTON_MINHEIGHT, // match parent width
    ),
  ),
);

final elevatedButtonThemeDataDark = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: getColorFromHex(COLOR_1),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
    ),
    minimumSize: const Size.fromHeight(
      BUTTON_MINHEIGHT, // match parent width
    ),
  ),
);

final outlinedButtonThemeDataDark = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: getColorFromHex(COLOR_1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
    ),
    minimumSize: const Size.fromHeight(
      BUTTON_MINHEIGHT, // match parent width
    ),
  ),
);

const textThemeDark = TextTheme(
  labelLarge: TextStyle(
    fontSize: 10 * GOLDEN_RATIO,
    color: Colors.white,
  ), // button
  labelMedium: TextStyle(
    fontSize: 10 * GOLDEN_RATIO,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  labelSmall: TextStyle(
    fontSize: 8 * GOLDEN_RATIO,
    color: Colors.white,
  ),
  titleLarge: TextStyle(
    fontSize: 12 * GOLDEN_RATIO,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  ),
  titleMedium: TextStyle(
    fontSize: 10 * GOLDEN_RATIO,
    color: Colors.white,
  ), // subtitle 1 - textformfield
  titleSmall: TextStyle(
    fontSize: 9 * GOLDEN_RATIO,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  ), // subtitle 2
);

final inputDecorationThemeDark = InputDecorationTheme(
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(TEXTFORMFIELD_BORDER_RAD),
  ),
);
