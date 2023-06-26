import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';
import 'route.dart';
import 'theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    return MaterialApp(
      theme: appThemeData,
      darkTheme: appThemeDataDark,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const Home(),
    );
  }
}
