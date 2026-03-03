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
    startListening();
  }

  void startListening() {
    final chatStream = _service.getChatMessages(currentUserId, receiverId);
    _messagesSub = chatStream.listen((msgs) {
      _messages = msgs;
      emitCurrentState();
    }, onError: (e) => emit(ChatError(e.toString())));

    _userSub = _service.getUserStream(receiverId).listen((data) {
      _receiverData = data;
      emitCurrentState();
    }, onError: (e) => emit(ChatError(e.toString())));
  }

  void emitCurrentState() {
    emit(
      ChatLoaded(
        messages: List.from(_messages),
        receiverName: _receiverData?["name"],
        receiverPhoto: _receiverData?["image"],
        isOnline: _receiverData?["isOnline"] ?? false,
        isTyping: _receiverData?["isTyping"] ?? false,
        lastSeen: (_receiverData?["lastSeen"] as Timestamp?)?.toDate(),
      ),
    );
  }

  Future<void> sendText(String text) async {
    print("Sending text...");
    if (text.trim().isEmpty) return;

    final msg = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      type: "text",
      text: text.trim(),
      sentAt: DateTime.now(),
    );

    await _service.sendMessage(msg);
    print("Message sent!");
  }

  Future<void> sendVoice(String base64String) async {
    if (base64String.isEmpty) {
      return;
    }

    final msg = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      type: "voice",
      voiceBase64: base64String,
      sentAt: DateTime.now(),
    );

    try {
      await _service.sendMessage(msg);
      //print("   Firestore sucess");
    } catch (e) {
      return;
    }
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
