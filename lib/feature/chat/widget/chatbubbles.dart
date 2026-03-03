import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/core/model/message.dart';
import 'package:chatwala/feature/chat/widget/image_bubble.dart';
import 'package:chatwala/feature/chat/widget/voicebubble.dart';
import 'package:flutter/material.dart';


class MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;
  final bool isSender;
  final Color? color;

  const MessageStatusIcon({
    super.key,
    required this.status,
    required this.isSender,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSender) return const SizedBox.shrink();

    switch (status) {
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 14,
          color: color ?? Colors.white.withValues(alpha: 0.7),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 14,
          color: color ?? Colors.white.withValues(alpha: 0.7),
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 14,
          color: Color(0xFF34B7F1), // WhatsApp blue tick
        );
    }
  }
}

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message.text ?? '',
                  style: TextStyle(
                    color: isSender
                        ? Colors.white
                        : AppTheme.textPrimary(context),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${message.sentAt.hour.toString().padLeft(2, '0')}:"
                    "${message.sentAt.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 10,
                      color: isSender
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppTheme.textHint(context),
                    ),
                  ),
                  if (isSender) ...[
                    const SizedBox(width: 3),
                    MessageStatusIcon(
                      status: message.status,
                      isSender: isSender,
                    ),
                  ],
                ],
              ),
            ],
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
          durationMs: message.voiceDurationMs,
          messageStatus: message.status,
          sentAt: message.sentAt,
        );
      case 'image':
        return ImageBubble(message: message, isSender: isSender);
      default:
        return const SizedBox();
    }
  }
}
