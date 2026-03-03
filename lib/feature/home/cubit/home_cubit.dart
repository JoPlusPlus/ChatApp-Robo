import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/const.dart';
import '../../../core/model/message.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final String currentUserId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription? _usersSub;
  final Map<String, StreamSubscription> _lastMsgSubs = {};
  final Map<String, String?> _lastMessages = {};
  final Map<String, DateTime?> _lastMessageTimes = {};

  List<ChatUser> _rawUsers = [];

  HomeCubit({required this.currentUserId}) : super(HomeLoading()) {
    _listenToUsers();
  }

  void _listenToUsers() {
    _usersSub = _db.collection(AppConstants.usersCollection).snapshots().listen(
      (snapshot) {
        _rawUsers = snapshot.docs
            .where((doc) => doc.id != currentUserId)
            .map((doc) => ChatUser.fromFirestore(doc.data(), doc.id))
            .toList();

        // Listen to last message for each user
        for (final user in _rawUsers) {
          if (!_lastMsgSubs.containsKey(user.uid)) {
            _listenToLastMessage(user.uid);
          }
        }

        _emitLoaded();
      },
      onError: (e) => emit(HomeError(e.toString())),
    );
  }

  void _listenToLastMessage(String otherUid) {
    final ids = [currentUserId, otherUid]..sort();
    final chatId = ids.join('_');

    _lastMsgSubs[otherUid] = _db
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snap) {
          if (snap.docs.isNotEmpty) {
            final data = snap.docs.first.data();
            final msg = Message.fromFirestore(data, snap.docs.first.id);
            if (msg.type == 'text') {
              _lastMessages[otherUid] = msg.text ?? '';
            } else if (msg.type == 'voice') {
              _lastMessages[otherUid] = '🎤 Voice note';
            }
            _lastMessageTimes[otherUid] = msg.sentAt;
          } else {
            _lastMessages[otherUid] = null;
            _lastMessageTimes[otherUid] = null;
          }
          _emitLoaded();
        });
  }

  void _emitLoaded() {
    final query = (state is HomeLoaded)
        ? (state as HomeLoaded).searchQuery
        : '';

    final enriched = _rawUsers.map((u) {
      return u.copyWith(
        lastMessage: _lastMessages[u.uid],
        lastMessageTime: _lastMessageTimes[u.uid],
      );
    }).toList();

    // Sort by last message time (most recent first), users without messages go to the end
    enriched.sort((a, b) {
      if (a.lastMessageTime == null && b.lastMessageTime == null) {
        return a.name.compareTo(b.name);
      }
      if (a.lastMessageTime == null) return 1;
      if (b.lastMessageTime == null) return -1;
      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });

    final active = enriched.where((u) => u.isOnline).toList();

    emit(
      HomeLoaded(allUsers: enriched, activeUsers: active, searchQuery: query),
    );
  }

  void search(String query) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(
        HomeLoaded(
          allUsers: current.allUsers,
          activeUsers: current.activeUsers,
          searchQuery: query,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _usersSub?.cancel();
    for (final sub in _lastMsgSubs.values) {
      sub.cancel();
    }
    return super.close();
  }
}
