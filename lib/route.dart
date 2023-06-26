import 'dart:io';

import 'package:app/home.dart';
import 'package:app/play_recording.dart';
import 'package:app/record_data_screen.dart';
import 'package:flutter/material.dart';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RecordDataScreen.route:
      return MaterialPageRoute(
        builder: (context) => const RecordDataScreen(),
      );
    case Home.route:
      return MaterialPageRoute(
        builder: (context) => const Home(),
      );
    case PlayRecordingScreen.route:
      final recording = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => PlayRecordingScreen(recording: recording),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text("Page not found"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Home.route,
                    );
                  },
                  child: const Text("Go back Home"),
                )
              ],
            ),
          ),
        ),
      );
  }
}
