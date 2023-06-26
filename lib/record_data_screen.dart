import 'dart:io';

import 'package:app/home.dart';
import 'package:app/play_recording.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RecordDataScreen extends StatefulWidget {
  const RecordDataScreen({super.key});
  static const String route = "record_data_screen";

  @override
  State<RecordDataScreen> createState() => _RecordDataScreenState();
}

class _RecordDataScreenState extends State<RecordDataScreen> {
  var recording = <File>[];

  void updateRecordings() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = "${directory.path}/recordings/";
    if (!Directory(path).existsSync()) {
      final createPath = Directory(path).create(recursive: true);
      print(createPath);
    }
    final recordingDirectory = Directory(path);
    if (recordingDirectory.existsSync()) {
      List<FileSystemEntity> entities =
          recordingDirectory.listSync(recursive: false);

      for (FileSystemEntity entity in entities) {
        if (entity is File) {
          recording.add(entity);
          setState(() {});
        }
      }
    }
  }

  void deleteRecording(File filePath) {
    if (filePath.existsSync()) {
      filePath.deleteSync();
    }
    recording.remove(filePath);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateRecordings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: recording.isEmpty
                    ? const Text("RECORDING EMPTY")
                    : ListView(
                        children: recording
                            .map(
                              (e) => ListTile(
                                onTap: () => Navigator.pushNamed(
                                    context, PlayRecordingScreen.route,
                                    arguments: e),
                                title: Text(
                                  e.path.split("/").last.split(".").first,
                                ),
                                trailing: IconButton(
                                  onPressed: () => deleteRecording(e),
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              const Divider(),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Home.route);
                    },
                    child: const Icon(
                      Icons.circle_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
