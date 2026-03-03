import 'package:chatapp/core/constant/const.dart';
import 'package:chatapp/core/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _getChatId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

Future<void> sendMessage(Message msg) async {
  final chatId = _getChatId(msg.senderId, msg.receiverId);
  //print("ChatService → sendMessage ");

  try {
    await _db
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .add(msg.toFirestore());
  
  } catch (e, st) {
   
    return;
    
  }
}
  Stream<List<Message>> getChatMessages(String uid1, String uid2) {
    final chatId = _getChatId(uid1, uid2);
    return _db
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Message.fromFirestore(doc.data(), doc.id)).toList());
  }

  Stream<Map<String, dynamic>?> getUserStream(String uid) {
    return _db.collection(AppConstants.usersCollection).doc(uid).snapshots().map((doc) => doc.data());
  }


Future<void> setOnline(String uid, bool online) async {
  await _db.collection('users').doc(uid).set({
    'isOnline': online,
    'lastSeen': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}


Future<void> setTyping(String uid, bool typing) async {
  await _db.collection('users').doc(uid).set({
    'isTyping': typing,
    'isOnline': true, 
    'lastSeen': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
}