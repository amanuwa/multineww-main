// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MaterialApp(
    home: VideoPlayerList(),
  ));
}

class VideoPlayerList extends StatefulWidget {
  const VideoPlayerList({Key? key}) : super(key: key);

  @override
  _VideoPlayerListState createState() => _VideoPlayerListState();
}

class _VideoPlayerListState extends State<VideoPlayerList> {
  late List<VideoPlayerController> _controllers;
  late List<Future<void>> _initializeVideoPlayerFutures;

  @override
  void initState() {
    super.initState();

    List<String> videoPaths = [
      'assets/sec2.mp4',
      'assets/sec1.mp4',
      'assets/sec3.mp4',
    ];

    _controllers = videoPaths
        .map((path) => VideoPlayerController.asset(path)..setLooping(true))
        .toList();

    _initializeVideoPlayers();
  }

  Future<void> _initializeVideoPlayer(VideoPlayerController controller) async {
    if (!controller.value.isInitialized) {
      await controller.initialize();
    }
  }

  Future<void> _initializeVideoPlayers() async {
    await Future.wait(
      _controllers.map((controller) => _initializeVideoPlayer(controller)),
    );

    setState(() {
      for (var controller in _controllers) {
        controller.play();
        controller.setLooping(true);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            height: 50,
            width: 50,
            child: const Center(child: Text('Lunch')),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            height: 1000,
            width: 500,
            child: ListView.builder(
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 300,
                  width: 500,
                  child: VideoPlayerItem(controller: _controllers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayerItem({Key? key, required this.controller}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: VideoPlayer(widget.controller),
    );
  }
}
