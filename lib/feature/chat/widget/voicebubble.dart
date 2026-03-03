import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatwala/core/model/message.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/widget/chatbubbles.dart';
import 'package:flutter/material.dart';

class VoiceBubble extends StatefulWidget {
  final String base64Audio;
  final bool isSender;
  final int? durationMs;
  final MessageStatus? messageStatus;
  final DateTime? sentAt;

  const VoiceBubble({
    super.key,
    required this.base64Audio,
    required this.isSender,
    this.durationMs,
    this.messageStatus,
    this.sentAt,
  });

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble> {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool hasError = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.durationMs != null) {
      _totalDuration = Duration(milliseconds: widget.durationMs!);
    }
    player.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    player.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _totalDuration = dur);
    });
    player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(1, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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

  Future<void> _pauseAudio() async {
    await player.pause();
    setState(() => isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);
    final senderColor = primaryColor;
    final receiverColor = AppTheme.card(context);
    final textColor = widget.isSender
        ? Colors.white
        : AppTheme.textPrimary(context);

    final progress = _totalDuration.inMilliseconds > 0
        ? (_position.inMilliseconds / _totalDuration.inMilliseconds).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.70,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Play / Pause button
              GestureDetector(
                onTap: () async {
                  if (isPlaying) {
                    await _pauseAudio();
                  } else {
                    await _playAudio();
                  }
                },
                child: Container(
                  width: 38,
                  height: 38,
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
              const SizedBox(width: 8),
              // Waveform + progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Waveform bars
                    SizedBox(
                      height: 24,
                      child: Row(
                        children: List.generate(20, (i) {
                          final h = (6.0 + (i % 3) * 5.0 + (i % 5) * 3.0).clamp(
                            4.0,
                            20.0,
                          );
                          final isActive = i / 20 <= progress;
                          return Expanded(
                            child: Container(
                              height: h,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0.5,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? (widget.isSender
                                          ? Colors.white
                                          : primaryColor)
                                    : textColor.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Duration
                    Text(
                      isPlaying
                          ? _formatDuration(_position)
                          : _formatDuration(_totalDuration),
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppTheme.error,
                    size: 16,
                  ),
                ),
            ],
          ),
          // Time + status
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.sentAt != null)
                Text(
                  "${widget.sentAt!.hour.toString().padLeft(2, '0')}:"
                  "${widget.sentAt!.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.isSender
                        ? Colors.white.withValues(alpha: 0.6)
                        : AppTheme.textHint(context),
                  ),
                ),
              if (widget.isSender && widget.messageStatus != null) ...[
                const SizedBox(width: 3),
                MessageStatusIcon(
                  status: widget.messageStatus!,
                  isSender: true,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
