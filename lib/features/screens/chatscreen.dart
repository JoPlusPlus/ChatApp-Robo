import 'dart:convert';
import 'dart:io';
import 'package:chatapp/features/data/chatservice.dart';
import 'package:chatapp/features/widget/chatbubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

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
      create: (_) => ChatCubit(
        ChatService(),
        widget.currentUserId,
        widget.receiverId,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.receiverImage != null
                    ? NetworkImage(widget.receiverImage!)
                    : null,
                child: widget.receiverImage == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.receiverName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoaded) {
                        if (state.isTyping) {
                          return const Text(
                            "Typing...",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          );
                        }
                        if (state.isOnline) {
                          return const Text(
                            "Online",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          );
                        } else {
                          return const Text(
                            "Offline",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          );
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                ],
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }

                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "No messages yet...",
                          style: TextStyle(color: Colors.grey),
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
                        final isMe =
                            message.senderId == widget.currentUserId;

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
                              ChatBubble(
                                message: message,
                                isSender: isMe,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "${message.sentAt.hour.toString().padLeft(2, '0')}:"
                                "${message.sentAt.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
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

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _textController,
                builder: (context, value, child) {
                  final hasText = value.text.trim().isNotEmpty;

                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: Icon(
                            hasText
                                ? Icons.send
                                : (isRecording ? Icons.stop : Icons.mic),
                            color: Colors.white,
                          ),
                          onPressed: () {
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
                        ),
                      ),
                    ],
                  );
                },
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