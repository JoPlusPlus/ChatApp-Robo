import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoiceBubble extends StatefulWidget {
  final String base64Audio;
  final bool isSender;

  const VoiceBubble({super.key, required this.base64Audio, required this.isSender});

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble> {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool hasError = false;
  
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
Future<void> _playAudio() async {
  try {
   

    if (widget.base64Audio.isEmpty) {
     // print("Base64 empty");
      setState(() => hasError = true);
      return;
    }

    final bytes = base64Decode(widget.base64Audio);
    

    await player.play(BytesSource(bytes));
    //print("sound played succ");

    setState(() {
      isPlaying = true;
      hasError = false;
    });
  } catch (e, st) {
    
    setState(() => hasError = true);
  }
}

  @override
  Widget build(BuildContext context) {
   // print("VoiceBubble build: base64Audio = ${widget.base64Audio.length}");
    return Container(
      
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
       decoration: BoxDecoration(
            color: widget.isSender ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(16),
              bottomRight: const Radius.circular(16),
              topLeft: Radius.circular(widget.isSender ? 16 : 0),
              topRight: Radius.circular(widget.isSender ? 0 : 16),
            ),
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: widget.isSender ? Colors.white : Colors.black,
              size: 32,
            ),
            onPressed: () async {
              if (isPlaying) {
                await player.pause();
                setState(() => isPlaying = false);
              } else {
                await _playAudio();
              }
            },
          ),
          if (hasError)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.error, color: Colors.red, size: 20),
            ),
          const SizedBox(width: 8),
          Text(
            "Voice Note",
            style: TextStyle(
              color: widget.isSender ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}