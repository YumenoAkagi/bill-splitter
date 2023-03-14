import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/app_constants.dart';
import 'app/utils/app_themedata_light.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
          scaffoldBackgroundColor: Colors.white,
          filledButtonTheme: filledButtonThemeDataLight,
          elevatedButtonTheme: elevatedButtonThemeDataLight,
          outlinedButtonTheme: outlinedButtonThemeDataLight,
          textTheme: textThemeLight,
          inputDecorationTheme: inputDecorationThemeLight,
        ),
        darkTheme: ThemeData.dark().copyWith(),
        themeMode: ThemeMode.light,
      ),
    ),
  );
}
