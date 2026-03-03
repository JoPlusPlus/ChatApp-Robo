
import 'dart:async';
import 'package:chatapp/core/model/message.dart';
import 'package:chatapp/features/data/chatservice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService _service;
  final String currentUserId;
  final String receiverId;

  StreamSubscription? _messagesSub;
  StreamSubscription? _userSub;

  List<Message> _messages = [];
  Map<String, dynamic>? _receiverData;

  ChatCubit(this._service, this.currentUserId, this.receiverId) : super(ChatLoading()) {
    _startListening();
  }

  void _startListening() {
    final chatStream = _service.getChatMessages(currentUserId, receiverId);
    _messagesSub = chatStream.listen(
      (msgs) {
        _messages = msgs;
        _emitCurrentState();
      },
      onError: (e) => emit(ChatError(e.toString())),
    );

    _userSub = _service.getUserStream(receiverId).listen(
      (data) {
        _receiverData = data;
        _emitCurrentState();
      },
      onError: (e) => emit(ChatError(e.toString())),
    );
  }

  void _emitCurrentState() {
    emit(ChatLoaded(
      messages: List.from(_messages),
      receiverName: _receiverData?["name"],
      receiverPhoto: _receiverData?["image"],
      isOnline: _receiverData?["isOnline" ] ?? false,
      isTyping: _receiverData?["isTyping"] ?? false,
    ));
  }

  Future<void> sendText(String text) async {
    if (text.trim().isEmpty) return;
    final msg = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      type: "text",
      text: text.trim(),
      sentAt: DateTime.now(),
    );
    await _service.sendMessage(msg);
  }

  Future<void> sendVoice(String url) async {
    final msg = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      type: "voice",
      voiceUrl: url,
      sentAt: DateTime.now(),
    );
    await _service.sendMessage(msg);
  }

  Future<void> setMyTyping(bool typing) => _service.setTyping(currentUserId, typing);

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    _userSub?.cancel();
    return super.close();
  }
}