import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  late VideoPlayerController? _controller;

  VideoPlayerViewModel(String networkUrl) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(networkUrl));
    _controller?.initialize().then((_) {
      play();
      notifyListeners();
    });
  }

  VideoPlayerController? get controller => _controller;

  void play() {
    _controller?.play();
    notifyListeners();
  }

  void pause() {
    _controller?.pause();
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
