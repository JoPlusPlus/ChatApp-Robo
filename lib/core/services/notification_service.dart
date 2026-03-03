import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constant/const.dart';
import '../model/message.dart';


class ChatNotification {
  final String senderName;
  final String senderPhoto;
  final String senderId;
  final String messageText;
  final String messageType;
  final DateTime time;

  ChatNotification({
    required this.senderName,
    required this.senderPhoto,
    required this.senderId,
    required this.messageText,
    required this.messageType,
    required this.time,
  });
}


class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String currentUserId;
  final Map<String, StreamSubscription> _chatSubs = {};
  final Map<String, String> _lastSeenMessageIds = {};

  final StreamController<ChatNotification> _notificationController =
      StreamController<ChatNotification>.broadcast();

  Stream<ChatNotification> get notificationStream =>
      _notificationController.stream;

  
  String? activeChatUserId;

  NotificationService({required this.currentUserId});

  void startListening() {
    // Listen to all chats the user is part of
    _db
        .collection(AppConstants.chatsCollection)
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .listen((snapshot) {
          for (final doc in snapshot.docs) {
            final chatId = doc.id;
            if (!_chatSubs.containsKey(chatId)) {
              _listenToChat(chatId);
            }
          }
        });
  }

  void _listenToChat(String chatId) {
    _chatSubs[chatId] = _db
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snap) async {
          if (snap.docs.isEmpty) return;
          final doc = snap.docs.first;
          final msg = Message.fromFirestore(doc.data(), doc.id);

          // Skip own messages
          if (msg.senderId == currentUserId) return;

          // Skip if this is the active chat
          if (activeChatUserId == msg.senderId) return;

          // Skip already seen messages
          if (_lastSeenMessageIds[chatId] == doc.id) return;
          _lastSeenMessageIds[chatId] = doc.id;

          // Fetch sender info
          final senderDoc = await _db
              .collection(AppConstants.usersCollection)
              .doc(msg.senderId)
              .get();
          final senderData = senderDoc.data() ?? {};

          _notificationController.add(
            ChatNotification(
              senderName: senderData['name'] ?? 'Unknown',
              senderPhoto: senderData['photoUrl'] ?? '',
              senderId: msg.senderId,
              messageText: msg.type == 'voice'
                  ? '🎤 Voice message'
                  : (msg.text ?? ''),
              messageType: msg.type,
              time: msg.sentAt,
            ),
          );
        });
  }

  void dispose() {
    for (final sub in _chatSubs.values) {
      sub.cancel();
    }
    _chatSubs.clear();
    _notificationController.close();
  }
}


class InAppNotificationOverlay extends StatefulWidget {
  final ChatNotification notification;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const InAppNotificationOverlay({
    super.key,
    required this.notification,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<InAppNotificationOverlay> createState() =>
      _InAppNotificationOverlayState();
}

class _InAppNotificationOverlayState extends State<InAppNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2A2A3C)
                : Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          widget.notification.senderPhoto.isNotEmpty
                          ? NetworkImage(widget.notification.senderPhoto)
                          : null,
                      child: widget.notification.senderPhoto.isEmpty
                          ? Text(
                              widget.notification.senderName.isNotEmpty
                                  ? widget.notification.senderName[0]
                                        .toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.notification.senderName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.notification.messageText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
