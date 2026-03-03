import 'package:chatapp/features/data/voiceservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';

class MessageInput extends StatefulWidget {
  final String currentUserId;
  final String receiverId;

  const MessageInput({
    super.key,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _textController = TextEditingController();
  bool _isRecording = false;
  String? _currentRecordingPath;
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _textController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    // تحقق من إذن المايك
    final hasPermission = await _audioService.init();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission is required")),
      );
      return;
    }

    // بدء التسجيل
    final path = await _audioService.startRecording();
    if (path != null) {
      setState(() {
        _isRecording = true;
        _currentRecordingPath = path;
      });
    }
  }

  Future<void> _stopRecordingAndSend() async {
    await _audioService.stopRecording();
    setState(() => _isRecording = false);

    if (_currentRecordingPath != null) {
      context.read<ChatCubit>().sendVoice(_currentRecordingPath!);
      _currentRecordingPath = null;
    }
  }

  void _sendText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendText(text);
    _textController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _textController.text.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isRecording)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.mic, color: Colors.red),
                const SizedBox(width: 8),
                const Text("Recording..."),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.stop, color: Colors.red),
                  onPressed: _stopRecordingAndSend,
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onChanged: (text) => setState(() {}),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: "Message",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: Icon(
                    hasText ? Icons.send : (_isRecording ? Icons.stop : Icons.mic),
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (hasText) {
                      _sendText();
                    } else {
                      if (_isRecording) {
                        _stopRecordingAndSend();
                      } else {
                        _startRecording();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}