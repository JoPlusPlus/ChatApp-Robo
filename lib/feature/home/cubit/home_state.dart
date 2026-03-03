import 'package:cloud_firestore/cloud_firestore.dart';


class ChatUser {
  final String uid;
  final String name;
  final String? email;
  final String? photoUrl;
  final bool isOnline;
  final bool isTyping;
  final DateTime? lastSeen;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  const ChatUser({
    required this.uid,
    required this.name,
    this.email,
    this.photoUrl,
    this.isOnline = false,
    this.isTyping = false,
    this.lastSeen,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatUser.fromFirestore(Map<String, dynamic> data, String uid) {
    final rawPhoto = data['photoUrl'] ?? data['image'];
    final photo = (rawPhoto is String && rawPhoto.isNotEmpty) ? rawPhoto : null;
    return ChatUser(
      uid: uid,
      name: data['name'] ?? data['displayName'] ?? 'Unknown',
      email: data['email'],
      photoUrl: photo,
      isOnline: data['isOnline'] ?? false,
      isTyping: data['isTyping'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
    );
  }

  ChatUser copyWith({String? lastMessage, DateTime? lastMessageTime}) {
    return ChatUser(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      isOnline: isOnline,
      isTyping: isTyping,
      lastSeen: lastSeen,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}

/// states
sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ChatUser> allUsers;
  final List<ChatUser> activeUsers;
  final String searchQuery;

  HomeLoaded({
    required this.allUsers,
    required this.activeUsers,
    this.searchQuery = '',
  });

  List<ChatUser> get filteredAll {
    if (searchQuery.isEmpty) return allUsers;
    final q = searchQuery.toLowerCase();
    return allUsers
        .where(
          (u) =>
              u.name.toLowerCase().contains(q) ||
              (u.email?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  List<ChatUser> get filteredActive {
    if (searchQuery.isEmpty) return activeUsers;
    final q = searchQuery.toLowerCase();
    return activeUsers
        .where(
          (u) =>
              u.name.toLowerCase().contains(q) ||
              (u.email?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
