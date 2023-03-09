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
  color: Colors.white,
  elevation: 0,
  foregroundColor: getColorFromHex(COLOR_2),
);

const textThemeLight = TextTheme(
  titleLarge: TextStyle(fontSize: 12 * GOLDEN_RATIO),
  titleMedium: TextStyle(fontSize: 10 * GOLDEN_RATIO),
  titleSmall: TextStyle(fontSize: 8 * GOLDEN_RATIO),
);
