import 'dart:convert';
import 'dart:io';

import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../data/chatservice.dart';
import '../widget/chatbubbles.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final String? receiverImage;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
    this.receiverImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isRecording = false;
  String? path;

  final TextEditingController _textController = TextEditingController();
  final AudioRecorder recorder = AudioRecorder();

  bool _isTypingSent = false;

  @override
  void initState() {
    super.initState();

    ChatService().setOnline(widget.currentUserId, true);

    _textController.addListener(() {
      final isTypingNow = _textController.text.trim().isNotEmpty;

      if (isTypingNow != _isTypingSent) {
        ChatService().setTyping(widget.currentUserId, isTypingNow);
        _isTypingSent = isTypingNow;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    ChatService().setTyping(widget.currentUserId, false);
    _textController.dispose();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatCubit(ChatService(), widget.currentUserId, widget.receiverId),
      child: Scaffold(
        backgroundColor: AppTheme.background(context),
        appBar: AppBar(
          backgroundColor: AppTheme.surface(context),
          foregroundColor: AppTheme.textPrimary(context),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppTheme.textPrimary(context),
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primary(
                  context,
                ).withValues(alpha: 0.12),
                backgroundImage:
                    (widget.receiverImage != null &&
                        widget.receiverImage!.isNotEmpty)
                    ? NetworkImage(widget.receiverImage!)
                    : null,
                child:
                    (widget.receiverImage == null ||
                        widget.receiverImage!.isEmpty)
                    ? Text(
                        widget.receiverName.isNotEmpty
                            ? widget.receiverName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: AppTheme.primary(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.receiverName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    BlocBuilder<ChatCubit, ChatState>(
                      builder: (context, state) {
                        if (state is ChatLoaded) {
                          if (state.isTyping) {
                            return Text(
                              "Typing...",
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.primary(context),
                              ),
                            );
                          }
                          if (state.isOnline) {
                            return const Text(
                              "Online",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.success,
                              ),
                            );
                          } else {
                            return Text(
                              "Offline",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textHint(context),
                              ),
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primary(context),
                      ),
                    );
                  }

                  if (state is ChatError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: TextStyle(color: AppTheme.error),
                      ),
                    );
                  }

                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: AppTheme.textHint(context),
                              size: 56,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No messages yet...",
                              style: TextStyle(
                                color: AppTheme.textSecondary(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Say hello! 👋",
                              style: TextStyle(
                                color: AppTheme.textHint(context),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(12),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            state.messages[state.messages.length - 1 - index];
                        final isMe = message.senderId == widget.currentUserId;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              ChatBubble(message: message, isSender: isMe),
                              const SizedBox(height: 3),
                              Text(
                                "${message.sentAt.hour.toString().padLeft(2, '0')}:"
                                "${message.sentAt.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textHint(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface(context),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadow(context),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _textController,
                  builder: (context, value, child) {
                    final hasText = value.text.trim().isNotEmpty;
                    final primaryColor = AppTheme.primary(context);

                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.inputFill(context),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: _textController,
                              style: TextStyle(
                                color: AppTheme.textPrimary(context),
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(
                                  color: AppTheme.textHint(context),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient(context),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                final text = _textController.text.trim();

                                if (text.isNotEmpty) {
                                  context.read<ChatCubit>().sendText(text);
                                  _textController.clear();
                                  return;
                                }

                                if (isRecording) {
                                  stopRecord(context);
                                } else {
                                  startRecord();
                                }
                              },
                              child: Icon(
                                hasText
                                    ? Icons.send_rounded
                                    : (isRecording
                                          ? Icons.stop_rounded
                                          : Icons.mic_rounded),
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> startRecord() async {
    final hasPerm = await recorder.hasPermission();
    if (!hasPerm) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return;
      }
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/${Uuid().v1()}.m4a';
      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: path,
      );
      setState(() => isRecording = true);
    } catch (e) {
      return;
    }
  }

  Future<void> stopRecord(BuildContext context) async {
    String? finalPath = await recorder.stop();

    if (finalPath == null) {
      return;
    }

    try {
      final file = File(finalPath);
      if (!await file.exists()) {
        return;
      }

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      context.read<ChatCubit>().sendVoice(base64String);
    } catch (e) {
      return;
    }

    setState(() {
      isRecording = false;
      path = finalPath;
    });
  }
}
