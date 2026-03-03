import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/message.dart';
import '../data/chatservice.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService _service;
  final String currentUserId;
  final String receiverId;
  final DateTime? lastSeen;
  StreamSubscription? _messagesSub;
  StreamSubscription? _userSub;

  List<Message> _messages = [];
  Map<String, dynamic>? _receiverData;

  ChatCubit(this._service, this.currentUserId, this.receiverId, [this.lastSeen])
    : super(ChatLoading()) {
    // Mark existing unread messages as read immediately on open
    _markAsRead();
    startListening();
  }

  void startListening() {
    final chatStream = _service.getChatMessages(currentUserId, receiverId);
    _messagesSub = chatStream.listen((msgs) {
      _messages = msgs;
      // Mark incoming messages as read
      _markAsRead();
      emitCurrentState();
    }, onError: (e) => emit(ChatError(e.toString())));

    _userSub = _service.getUserStream(receiverId).listen((data) {
      _receiverData = data;
      emitCurrentState();
    }, onError: (e) => emit(ChatError(e.toString())));
  }

  Future<void> _markAsRead() async {
    final chatId = _service.getChatId(currentUserId, receiverId);
    await _service.markMessagesAsRead(chatId, currentUserId);
  }

  void emitCurrentState() {
    emit(
      ChatLoaded(
        messages: List.from(_messages),
        receiverName: _receiverData?["name"],
        receiverPhoto: _receiverData?["photoUrl"] ?? _receiverData?["image"],
        isOnline: _receiverData?["isOnline"] ?? false,
        isTyping: _receiverData?["isTyping"] ?? false,
        lastSeen: (_receiverData?["lastSeen"] as Timestamp?)?.toDate(),
      ),
    );
  }

  Future<void> sendText(String text) async {
    if (text.trim().isEmpty) return;

    final msg = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      type: "text",
      text: text.trim(),
      sentAt: DateTime.now(),
      status: MessageStatus.sent,
    );

    await _service.sendMessage(msg);
  }

  Future<void> sendVoice(String base64String, {int? durationMs}) async {
    if (base64String.isEmpty) return;

    final msg = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      type: "voice",
      voiceBase64: base64String,
      sentAt: DateTime.now(),
      status: MessageStatus.sent,
      voiceDurationMs: durationMs,
    );

    try {
      await _service.sendMessage(msg);
    } catch (e) {
      return;
    }
  }

  Future<void> sendImage(String imagePath) async {
    if (imagePath.isEmpty) return;
    try {
      await _service.sendImageMessage(
        senderId: currentUserId,
        receiverId: receiverId,
        imagePath: imagePath,
      );
    } catch (e) {
      return;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final chatId = _service.getChatId(currentUserId, receiverId);
    await _service.deleteMessage(chatId, messageId);
  }

  Future<void> deleteChat() async {
    await _service.deleteChat(currentUserId, receiverId);
  }

  Future<void> setMyTyping(bool typing) =>
      _service.setTyping(currentUserId, typing);

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    _userSub?.cancel();
    return super.close();
  }
}
