import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class VoiceBubble extends StatefulWidget {
  final String base64Audio;
  final bool isSender;

  const VoiceBubble({
    super.key,
    required this.base64Audio,
    required this.isSender,
  });

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
        setState(() => hasError = true);
        return;
      }

      final bytes = base64Decode(widget.base64Audio);
      await player.play(BytesSource(bytes));

      setState(() {
        isPlaying = true;
        hasError = false;
      });
    } catch (e) {
      setState(() => hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);
    final senderColor = primaryColor;
    final receiverColor = AppTheme.card(context);
    final textColor = widget.isSender
        ? Colors.white
        : AppTheme.textPrimary(context);

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: widget.isSender ? senderColor : receiverColor,
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
          topLeft: Radius.circular(widget.isSender ? 18 : 4),
          topRight: Radius.circular(widget.isSender ? 4 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow(context),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              if (isPlaying) {
                await player.pause();
                setState(() => isPlaying = false);
              } else {
                await _playAudio();
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.isSender
                    ? Colors.white.withValues(alpha: 0.2)
                    : primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: widget.isSender ? Colors.white : primaryColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Waveform visual placeholder
          Flexible(
            child: Row(
              children: List.generate(12, (i) {
                final h = (8.0 + (i % 3) * 6.0 + (i % 5) * 3.0).clamp(
                  6.0,
                  20.0,
                );
                return Container(
                  width: 3,
                  height: h,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: textColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(
                Icons.error_outline_rounded,
                color: AppTheme.error,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}
