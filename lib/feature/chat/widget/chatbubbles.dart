import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/widget/voicebubble.dart';
import 'package:flutter/material.dart';
import '../../../core/model/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isSender;

  const ChatBubble({super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);
    final senderColor = primaryColor;
    final receiverColor = AppTheme.card(context);

    switch (message.type) {
      case 'text':
        return Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: isSender ? senderColor : receiverColor,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(18),
              bottomRight: const Radius.circular(18),
              topLeft: Radius.circular(isSender ? 18 : 4),
              topRight: Radius.circular(isSender ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadow(context),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            message.text ?? '',
            style: TextStyle(
              color: isSender ? Colors.white : AppTheme.textPrimary(context),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        );
      case 'voice':
        if (message.voiceBase64 == null || message.voiceBase64!.isEmpty) {
          return Text(
            "Voice note unavailable",
            style: TextStyle(color: AppTheme.textHint(context), fontSize: 12),
          );
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
