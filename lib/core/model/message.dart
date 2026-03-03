import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;               
  final String senderId;
  final String receiverId;
  final String type;             
  final String? text;
  final String? voiceUrl;
  final DateTime sentAt;
          

  Message({
    this.id = '',
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.text,
    this.voiceUrl,
    required this.sentAt,
  });

  factory Message.fromFirestore(Map<String, dynamic> data, String docId) {
    return Message(
      id: docId,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      type: data['type'] ?? 'text',
      text: data['text'],
      voiceUrl: data['voiceUrl'],
      sentAt: (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      if (text != null) 'text': text,
      if (voiceUrl != null) 'voiceUrl': voiceUrl,
      'sentAt': Timestamp.fromDate(sentAt),
  
    };
  }
}