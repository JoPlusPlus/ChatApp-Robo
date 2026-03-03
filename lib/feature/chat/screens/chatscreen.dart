import 'dart:convert';
import 'dart:io';

import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/screens/chat_settings_screen.dart';
import 'package:chatwala/feature/chat/widget/attachment_sheet.dart';
import 'package:chatwala/feature/chat/widget/call_initiate_dialog.dart';
import 'package:chatwala/feature/chat/widget/chat_app_bar_title.dart';
import 'package:chatwala/feature/chat/widget/chat_input_bar.dart';
import 'package:chatwala/feature/chat/widget/chat_message_list.dart';
import 'package:chatwala/feature/chat/widget/search_chat_sheet.dart';
import 'package:chatwala/feature/chat/widget/voice_recording_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../data/chatservice.dart';

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
  DateTime? _recordingStartTime;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder recorder = AudioRecorder();
  final ImagePicker _imagePicker = ImagePicker();

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
    _scrollController.dispose();
    recorder.dispose();
    super.dispose();
  }

  void _openChatSettings(ChatState state) {
    bool isOnline = false;
    if (state is ChatLoaded) {
      isOnline = state.isOnline;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatSettingsScreen(
          receiverName: widget.receiverName,
          receiverImage: widget.receiverImage,
          receiverId: widget.receiverId,
          isOnline: isOnline,
        ),
      ),
    );
  }

  /// Pick image from given source and send it
  Future<void> _pickAndSendImage(BuildContext ctx, ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null && mounted) {
        AppToast.showInfo('Sending photo...');
        ctx.read<ChatCubit>().sendImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError('Failed to pick image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatCubit(ChatService(), widget.currentUserId, widget.receiverId),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
              title: ChatAppBarTitle(
                receiverName: widget.receiverName,
                receiverImage: widget.receiverImage,
                onTap: () {
                  final state = context.read<ChatCubit>().state;
                  _openChatSettings(state);
                },
              ),
              actions: [
                IconButton(
                  onPressed: () => showCallInitiateDialog(
                    context: context,
                    isVideo: true,
                    receiverName: widget.receiverName,
                    receiverImage: widget.receiverImage,
                  ),
                  icon: Icon(
                    Icons.videocam_outlined,
                    color: AppTheme.textSecondary(context),
                    size: 22,
                  ),
                ),
                IconButton(
                  onPressed: () => showCallInitiateDialog(
                    context: context,
                    isVideo: false,
                    receiverName: widget.receiverName,
                    receiverImage: widget.receiverImage,
                  ),
                  icon: Icon(
                    Icons.call_outlined,
                    color: AppTheme.textSecondary(context),
                    size: 22,
                  ),
                ),
                // More options
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppTheme.textSecondary(context),
                    size: 22,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'settings':
                        final state = context.read<ChatCubit>().state;
                        _openChatSettings(state);
                        break;
                      case 'search':
                        showSearchChatSheet(context);
                        break;
                      case 'wallpaper':
                        AppToast.showInfo(
                          'Wallpaper customization coming soon',
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'search', child: Text('Search')),
                    const PopupMenuItem(
                      value: 'wallpaper',
                      child: Text('Wallpaper'),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Text('Chat Settings'),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ChatMessageList(
                    currentUserId: widget.currentUserId,
                    scrollController: _scrollController,
                  ),
                ),
                if (isRecording)
                  VoiceRecordingOverlay(
                    isRecording: isRecording,
                    onCancel: () => _cancelRecord(),
                    onStop: () => stopRecord(context),
                  )
                else
                  ChatInputBar(
                    textController: _textController,
                    onAttachTap: () => showAttachmentSheet(
                      context: context,
                      onPickImage: (source) =>
                          _pickAndSendImage(context, source),
                    ),
                    onCameraTap: () =>
                        _pickAndSendImage(context, ImageSource.camera),
                    onSendText: (text) {
                      context.read<ChatCubit>().sendText(text);
                      _textController.clear();
                    },
                    onStartRecord: startRecord,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> startRecord() async {
    final hasPerm = await recorder.hasPermission();
    if (!hasPerm) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${const Uuid().v1()}.m4a';
      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: filePath,
      );
      setState(() {
        isRecording = true;
        _recordingStartTime = DateTime.now();
      });
    } catch (e) {
      return;
    }
  }

  Future<void> _cancelRecord() async {
    try {
      await recorder.stop();
    } catch (_) {}
    setState(() {
      isRecording = false;
      _recordingStartTime = null;
    });
  }

  Future<void> stopRecord(BuildContext context) async {
    final durationMs = _recordingStartTime != null
        ? DateTime.now().difference(_recordingStartTime!).inMilliseconds
        : null;

    String? finalPath = await recorder.stop();

    if (finalPath == null) {
      setState(() {
        isRecording = false;
        _recordingStartTime = null;
      });
      return;
    }

    try {
      final file = File(finalPath);
      if (!await file.exists()) return;

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      if (context.mounted) {
        context.read<ChatCubit>().sendVoice(
          base64String,
          durationMs: durationMs,
        );
      }
    } catch (e) {
      return;
    }

    setState(() {
      isRecording = false;
      path = finalPath;
      _recordingStartTime = null;
    });
  }
}
