import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayRecordingScreen extends StatefulWidget {
  const PlayRecordingScreen({required this.recording, super.key});
  static const String route = "play_recording_screen";
  final File recording;

  @override
  State<PlayRecordingScreen> createState() => _PlayRecordingScreenState();
}

class _PlayRecordingScreenState extends State<PlayRecordingScreen> {
  final audioPlayer = AudioPlayer();
  var isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.setFilePath(widget.recording.path);
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.recording;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 75,
                child: Icon(Icons.audiotrack_outlined),
              ),
              const SizedBox(height: 24),
              Text(widget.recording.path.split("/").last.split(".").first),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      isPlaying ? audioPlayer.pause() : audioPlayer.play();
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    icon: isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        audioPlayer.stop();
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      }
                    },
                    icon: const Icon(Icons.stop),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
