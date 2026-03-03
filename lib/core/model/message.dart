import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String type;
  final String? text;
  final DateTime sentAt;
  final String? voiceBase64;
  final MessageStatus status;
  final int? voiceDurationMs;
  final String? imageUrl;

  Message({
    this.id = '',
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.text,
    required this.sentAt,
    this.voiceBase64,
    this.status = MessageStatus.sent,
    this.voiceDurationMs,
    this.imageUrl,
  });

  factory Message.fromFirestore(Map<String, dynamic> data, String id) {
    final rawBase64 = data['voiceBase64'];
    MessageStatus status;
    switch (data['status'] ?? 'sent') {
      case 'delivered':
        status = MessageStatus.delivered;
        break;
      case 'read':
        status = MessageStatus.read;
        break;
      default:
        status = MessageStatus.sent;
    }

    return Message(
      id: id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      type: data['type'] ?? 'text',
      text: data['text'],
      voiceBase64: rawBase64 as String?,
      sentAt: (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: status,
      voiceDurationMs: data['voiceDurationMs'] as int?,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    final map = <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'sentAt': Timestamp.fromDate(sentAt),
      'status': status.name,
    };

    if (type == 'text' && text != null) {
      map['text'] = text!;
    }

    if (type == 'voice' && voiceBase64 != null && voiceBase64!.isNotEmpty) {
      map['voiceBase64'] = voiceBase64!;
    }

    if (voiceDurationMs != null) {
      map['voiceDurationMs'] = voiceDurationMs;
    }

    if (type == 'image' && imageUrl != null) {
      map['imageUrl'] = imageUrl!;
    }

    return map;
  }

  Message copyWith({MessageStatus? status}) {
    return Message(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      type: type,
      text: text,
      sentAt: sentAt,
      voiceBase64: voiceBase64,
      status: status ?? this.status,
      voiceDurationMs: voiceDurationMs,
      imageUrl: imageUrl,
    );
  }
}
