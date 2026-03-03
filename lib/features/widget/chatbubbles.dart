import 'package:chatapp/features/widget/voicebubble.dart';
import 'package:flutter/material.dart';
import '../../core/model/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isSender;

  const ChatBubble({super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case 'text':
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(16),
              bottomRight: const Radius.circular(16),
              topLeft: Radius.circular(isSender ? 16 : 0),
              topRight: Radius.circular(isSender ? 0 : 16),
            ),
          ),
          child: Text(
            message.text ?? '',
            style: TextStyle(color: isSender ? Colors.white : Colors.black),
          ),
        );
case 'voice':
  if (message.voiceBase64 == null || message.voiceBase64!.isEmpty) {
  
    return const Text(" emptyy");
  }
  return VoiceBubble(
    base64Audio: message.voiceBase64!,
    isSender: isSender,
  );
      default:
        return const SizedBox();
    }
  }
}