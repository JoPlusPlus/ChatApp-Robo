import 'dart:async';

import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/widget/call_action_button.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final String callerName;
  final String? callerImage;
  final bool isVideo;

  const CallScreen({
    super.key,
    required this.callerName,
    this.callerImage,
    this.isVideo = false,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _seconds = 0;
  Timer? _timer;
  bool _isMuted = false;
  bool _isSpeaker = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Simulate "connecting" for 2 seconds, then start timer
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    if (_seconds == 0) return 'Connecting...';
    final mins = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primary(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Pulsing avatar
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (_pulseController.value * 0.08);
                return Transform.scale(scale: scale, child: child);
              },
              child: CircleAvatar(
                radius: 60,
                backgroundColor: primary.withValues(alpha: 0.3),
                backgroundImage:
                    (widget.callerImage != null &&
                        widget.callerImage!.isNotEmpty)
                    ? NetworkImage(widget.callerImage!)
                    : null,
                child:
                    (widget.callerImage == null || widget.callerImage!.isEmpty)
                    ? Text(
                        widget.callerName.isNotEmpty
                            ? widget.callerName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.callerName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formattedTime,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: Colors.amber.shade300,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Demo mode — no real call',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade300,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CallActionButton(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  CallActionButton(
                    icon: _isSpeaker
                        ? Icons.volume_up_rounded
                        : Icons.volume_down_rounded,
                    label: 'Speaker',
                    isActive: _isSpeaker,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                  if (widget.isVideo)
                    CallActionButton(
                      icon: _isCameraOff
                          ? Icons.videocam_off_rounded
                          : Icons.videocam_rounded,
                      label: _isCameraOff ? 'Camera On' : 'Camera Off',
                      isActive: _isCameraOff,
                      onTap: () => setState(() => _isCameraOff = !_isCameraOff),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // End call button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                AppToast.showInfo('Call ended');
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.call_end_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
