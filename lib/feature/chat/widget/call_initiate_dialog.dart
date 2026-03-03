import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/screens/call_screen.dart';
import 'package:flutter/material.dart';

/// Shows a dialog to initiate an audio or video call.
void showCallInitiateDialog({
  required BuildContext context,
  required bool isVideo,
  required String receiverName,
  required String? receiverImage,
}) {
  final primary = AppTheme.primary(context);
  showDialog(
    context: context,
    builder: (dCtx) => AlertDialog(
      backgroundColor: AppTheme.surface(dCtx),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 40,
            backgroundColor: primary.withValues(alpha: 0.12),
            backgroundImage: (receiverImage != null && receiverImage.isNotEmpty)
                ? NetworkImage(receiverImage)
                : null,
            child: (receiverImage == null || receiverImage.isEmpty)
                ? Text(
                    receiverName.isNotEmpty
                        ? receiverName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            isVideo ? 'Video Call' : 'Voice Call',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary(dCtx),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            receiverName,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary(dCtx)),
          ),
          const SizedBox(height: 8),
          Text(
            'Calling feature requires a VoIP backend\n(e.g. Agora, WebRTC) to be integrated.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textHint(dCtx),
              height: 1.4,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dCtx),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppTheme.textSecondary(dCtx)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(dCtx);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CallScreen(
                  callerName: receiverName,
                  callerImage: receiverImage,
                  isVideo: isVideo,
                ),
              ),
            );
          },
          icon: Icon(
            isVideo ? Icons.videocam_rounded : Icons.call_rounded,
            size: 18,
          ),
          label: Text(isVideo ? 'Video Call' : 'Call'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ),
  );
}
