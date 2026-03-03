import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Audio extends StatefulWidget {
  final String? audioUrl;
  const Audio({super.key, required this.audioUrl});

  @override
  State<Audio> createState() => _AudioState();

}

class _AudioState extends State<Audio> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> play() async {
    try {
      await _player.setUrl(widget.audioUrl ?? '');
      _player.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  Future<void> stop() async {
    await _player.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Audio not available",
          style: TextStyle(color: Colors.deepOrange),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
            onPressed: isPlaying ? stop : play,
          ),
          const SizedBox(width: 8),
          Text(
            isPlaying ? "Playing..." : "Voice Note",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}