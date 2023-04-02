import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/app_constants.dart';
import 'app/utils/app_themedata_dark.dart';
import 'app/utils/app_themedata_light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init supabase client
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANONKEY,
  );
  Get.put<GetStorage>(GetStorage());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: APP_NAME,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: ThemeData(
          fontFamily: MAIN_FONT,
          appBarTheme: appBarThemeLight,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          filledButtonTheme: filledButtonThemeDataLight,
          elevatedButtonTheme: elevatedButtonThemeDataLight,
          outlinedButtonTheme: outlinedButtonThemeDataLight,
          textTheme: textThemeLight,
          inputDecorationTheme: inputDecorationThemeLight,
        ),
        darkTheme: ThemeData(
          fontFamily: MAIN_FONT,
          appBarTheme: appBarThemeDark,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: getColorFromHex(COLOR_DARK_MAIN),
          filledButtonTheme: filledButtonThemeDataDark,
          elevatedButtonTheme: elevatedButtonThemeDataDark,
          outlinedButtonTheme: outlinedButtonThemeDataDark,
          textTheme: textThemeDark,
          inputDecorationTheme: inputDecorationThemeDark,
        ),
        themeMode: ThemeMode.light,
      ),
    ),
  );
}
