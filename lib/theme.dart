import 'package:flutter/material.dart';

var appThemeData = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  navigationBarTheme:
      const NavigationBarThemeData(backgroundColor: Colors.black),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
      .copyWith(background: Colors.black),
);

var appThemeDataDark = ThemeData.dark(
  useMaterial3: true,
);
