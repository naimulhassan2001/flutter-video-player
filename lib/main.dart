import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4' // Replace with a valid video URL
    )
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        setState(() {
          _isError = true;
        });
        print('Error initializing video: $error');
      });

    _controller.addListener(() {
      if (_controller.value.hasError) {
        setState(() {
          _isError = true;
        });
        print('Video player had error: ${_controller.value.errorDescription}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player Example'),
      ),
      body: Center(
        child: _isError
            ? Text('An error occurred while playing the video.')
            : _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
