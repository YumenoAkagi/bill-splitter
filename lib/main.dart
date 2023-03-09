import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/app_constants.dart';
import 'app/utils/app_themedata_light.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        filledButtonTheme: filledButtonThemeDataLight,
        elevatedButtonTheme: elevatedButtonThemeDataLight,
        outlinedButtonTheme: outlinedButtonThemeDataLight,
        appBarTheme: appBarThemeLight,
        textTheme: textThemeLight,
      ),
      darkTheme: ThemeData.dark().copyWith(),
      themeMode: ThemeMode.light,
    ),
  );
}
