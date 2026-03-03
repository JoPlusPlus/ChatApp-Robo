


import '../../../core/model/message.dart';


sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final String? receiverName;
  final String? receiverPhoto;
  final bool isOnline;
  final bool isTyping;
final DateTime? lastSeen;
  ChatLoaded({
    required this.messages,
    this.receiverName,
    this.receiverPhoto,
    this.isOnline = false,
    this.isTyping = false,
    this.lastSeen,
  });
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}