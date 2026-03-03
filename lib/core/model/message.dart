import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;               
  final String senderId;
  final String receiverId;
  final String type;             
  final String? text;
 
  final DateTime sentAt;
  final String? voiceBase64;
          

  Message({
    this.id = '',
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.text,
   
    required this.sentAt,
    this.voiceBase64,
  });


  factory Message.fromFirestore(Map<String, dynamic> data, String id) {
  final rawBase64 = data['voiceBase64'];
 

  return Message(
    senderId: data['senderId'] ?? '',
    receiverId: data['receiverId'] ?? '',
    type: data['type'] ?? 'text',
    text: data['text'],
    voiceBase64: rawBase64 as String?,
    sentAt: (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
  Map<String, dynamic> toFirestore() {
    final map = {
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'sentAt': Timestamp.fromDate(sentAt),
    };

    if (type == 'text' && text != null) {
      map['text'] = text!;
    }

    if (type == 'voice' && voiceBase64 != null && voiceBase64!.isNotEmpty) {
      map['voiceBase64'] = voiceBase64!;
     
    } 

    return map;
  }
}