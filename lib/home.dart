import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app/record_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String route = "home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var minute = 0;
  var seconds = 0;
  var millisecond = 0;
  var isRecording = false;
  var isPaused = false;
  late TextEditingController recordTitleController;
  var record = Record();

  var duration = const Duration(milliseconds: 10);

  late Timer timer;

  Future<String> setName(String title) async {
    var paths = <String>[];
    var newname = title;
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
          paths.add(entity.path.split("/").last.split(".").first);
        }
      }
    }

    while (paths.contains(newname)) {
      List<String> titles =
          paths.where((element) => element.contains(title)).toList();
      titles.sort();
      RegExp regex = RegExp(r'^(.*?)(\d+)$');
      RegExpMatch? match = regex.firstMatch(titles.last);
      if (match != null) {
        String substring = match.group(1)!;
        String number = match.group(2)!;
        newname = "$substring${int.parse(number) + 1}";
      } else {
        newname = "${newname}1";
      }
    }
    return newname;
  }

  void increaseTime() {
    if (millisecond == 100) {
      millisecond = 0;
      seconds += 1;
    } else if (seconds == 60) {
      seconds = 0;
      minute += 1;
    }
    millisecond++;
    setState(() {});
  }

  void start() async {
    var directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/recordings/";

    if (!Directory(path).existsSync()) {
      final createdDirectory = await Directory(path).create(recursive: true);
      print(createdDirectory);
    }

    log("path: $path");
    late String name;
    if (recordTitleController.text.isNotEmpty) {
      name = recordTitleController.text;
    } else {
      name = "Record";
    }
    name = await setName(name);
    if (await record.hasPermission()) {
      await record.start(path: "$path$name.rn");
      isRecording = await record.isRecording();
      isPaused = await record.isPaused();
      Timer.periodic(duration, (timer) {
        if (!isRecording || isPaused) {
          timer.cancel();
        }
        increaseTime();
      });
    } else {
      log("no permission");
    }
  }

  void stop() async {
    isRecording = false;
    isPaused = false;
    await record.stop();
    minute = 0;
    seconds = 0;
    millisecond = 0;
    setState(() {});
  }

  void pause() async {
    await record.pause();
    isPaused = await record.isPaused();

    setState(() {});
  }

  void resume() async {
    await record.resume();
    isPaused = await record.isPaused();
    isRecording = await record.isRecording();
    Timer.periodic(duration, (timer) {
      if (!isRecording || isPaused) {
        timer.cancel();
      }
      increaseTime();
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    recordTitleController = TextEditingController();
  }

  @override
  void dispose() {
    recordTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: recordTitleController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "recording name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Text(
                    "${minute.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}:${millisecond.toString().padLeft(2, "0")}",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.circle,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, RecordDataScreen.route);
                    },
                    child: const Icon(
                      Icons.circle_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.flag,
                      size: 35,
                    ),
                  ),
                  GestureDetector(
                    onTap: isPaused
                        ? resume
                        : isRecording
                            ? pause
                            : start,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.secondary,
                              offset: const Offset(-.5, -.5),
                              blurRadius: 1.5,
                            )
                          ]),
                      child: Center(
                        child: Icon(
                          isPaused
                              ? Icons.restart_alt
                              : isRecording
                                  ? Icons.mic_off
                                  : Icons.mic,
                          color: Colors.grey,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: stop,
                    icon: const Icon(
                      Icons.square,
                      size: 35,
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}
