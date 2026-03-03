import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/constant/const.dart';
import '../../../core/model/message.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _getChatId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

  /// Get chatId (public for external use)
  String getChatId(String uid1, String uid2) => _getChatId(uid1, uid2);

  Future<void> sendMessage(Message msg) async {
    final chatId = _getChatId(msg.senderId, msg.receiverId);
    try {
      final docRef = await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .add(msg.toFirestore());

      // Update chat metadata for last message preview
      String lastMsg;
      switch (msg.type) {
        case 'voice':
          lastMsg = '🎤 Voice note';
          break;
        case 'image':
          lastMsg = '📷 Photo';
          break;
        default:
          lastMsg = msg.text ?? '';
      }
      await _db.collection(AppConstants.chatsCollection).doc(chatId).set({
        'participants': [msg.senderId, msg.receiverId],
        'lastMessage': lastMsg,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSenderId': msg.senderId,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Auto-mark as delivered after sending
      await docRef.update({'status': 'delivered'});
    } catch (e) {
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
        .map(
          (snap) => snap.docs
              .map((doc) => Message.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Mark all messages from a sender as read
  Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    try {
      final query = await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .where('receiverId', isEqualTo: currentUserId)
          .where('status', whereIn: ['sent', 'delivered'])
          .get();

      if (query.docs.isEmpty) return;

      final batch = _db.batch();
      for (final doc in query.docs) {
        batch.update(doc.reference, {'status': 'read'});
      }
      await batch.commit();

      // Touch the chat document so getTotalUnreadCount stream re-fires
      await _db.collection(AppConstants.chatsCollection).doc(chatId).set({
        'lastReadAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // silently fail
    }
  }

  /// Get unread message count for a specific chat
  Stream<int> getUnreadCount(String currentUserId, String otherUserId) {
    final chatId = _getChatId(currentUserId, otherUserId);
    return _db
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .where('receiverId', isEqualTo: currentUserId)
        .where('status', whereIn: ['sent', 'delivered'])
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  /// Get total unread count across all chats
  Stream<int> getTotalUnreadCount(String currentUserId) {
    return _db
        .collection(AppConstants.chatsCollection)
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((chatSnap) async {
          int total = 0;
          for (final chatDoc in chatSnap.docs) {
            final unreadSnap = await chatDoc.reference
                .collection(AppConstants.messagesCollection)
                .where('receiverId', isEqualTo: currentUserId)
                .where('status', whereIn: ['sent', 'delivered'])
                .get();
            total += unreadSnap.docs.length;
          }
          return total;
        });
  }

  /// Get all users (for new chat picker)
  Stream<List<Map<String, dynamic>>> getAllUsers(String excludeUid) {
    return _db
        .collection(AppConstants.usersCollection)
        .snapshots()
        .map(
          (snap) => snap.docs
              .where((doc) => doc.id != excludeUid)
              .map((doc) => {'uid': doc.id, ...doc.data()})
              .toList(),
        );
  }

  Stream<Map<String, dynamic>?> getUserStream(String uid) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<void> setOnline(String uid, bool online) async {
    await _db.collection(AppConstants.usersCollection).doc(uid).set({
      'isOnline': online,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> setTyping(String uid, bool typing) async {
    await _db.collection(AppConstants.usersCollection).doc(uid).set({
      'isTyping': typing,
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Save or update user profile in Firestore when they authenticate
  Future<void> saveUserProfile({
    required String uid,
    required String name,
    String? email,
    String? photoUrl,
  }) async {
    await _db.collection(AppConstants.usersCollection).doc(uid).set({
      'name': name,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Upload image to Firebase Storage and return download URL
  Future<String?> uploadChatImage(String filePath, String chatId) async {
    try {
      final file = File(filePath);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final ref = FirebaseStorage.instance.ref().child(
        'chat_images/$chatId/$fileName',
      );
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  /// Send an image message
  Future<void> sendImageMessage({
    required String senderId,
    required String receiverId,
    required String imagePath,
  }) async {
    final chatId = _getChatId(senderId, receiverId);
    final imageUrl = await uploadChatImage(imagePath, chatId);
    if (imageUrl == null) return;

    final msg = Message(
      senderId: senderId,
      receiverId: receiverId,
      type: 'image',
      imageUrl: imageUrl,
      sentAt: DateTime.now(),
      status: MessageStatus.sent,
    );
    await sendMessage(msg);
  }

  /// Delete a single message
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .delete();
    } catch (e) {
      // silently fail
    }
  }

  /// Delete entire chat (all messages + chat document)
  Future<void> deleteChat(String uid1, String uid2) async {
    final chatId = _getChatId(uid1, uid2);
    try {
      // Delete all messages in sub-collection
      final msgs = await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .get();
      final batch = _db.batch();
      for (final doc in msgs.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Delete the chat document itself
      await _db.collection(AppConstants.chatsCollection).doc(chatId).delete();
    } catch (e) {
      // silently fail
    }
  }

  /// Set user offline when they sign out or app closes
  Future<void> setOffline(String uid) async {
    await _db.collection(AppConstants.usersCollection).doc(uid).set({
      'isOnline': false,
      'isTyping': false,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
