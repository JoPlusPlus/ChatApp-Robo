import 'dart:async';
import 'package:chatwala/core/services/notification_service.dart';
import 'package:chatwala/feature/chat/screens/new_chat_screen.dart';
import 'package:chatwala/feature/chat/screens/new_call_screen.dart';
import 'package:chatwala/feature/home/pages/home_page.dart';
import 'package:chatwala/feature/home/pages/calls_page.dart';
import 'package:chatwala/feature/home/pages/status_page.dart';
import 'package:chatwala/feature/home/cubit/home_cubit.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/profile/pages/profile_screen.dart';
import 'package:chatwala/feature/auth/logic/auth_cubit.dart';
import 'package:chatwala/feature/chat/data/chatservice.dart';
import 'package:chatwala/feature/chat/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  HomeCubit? _homeCubit;
  String _lastUserId = '';
  NotificationService? _notificationService;
  StreamSubscription? _notifSub;
  int _totalUnread = 0;
  StreamSubscription? _unreadSub;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _initNotifications(String userId) {
    _notificationService?.dispose();
    _notificationService = NotificationService(currentUserId: userId);
    _notificationService!.startListening();

    _notifSub?.cancel();
    _notifSub = _notificationService!.notificationStream.listen((notification) {
      if (!mounted) return;
      _showInAppNotification(notification);
    });

    // Listen to total unread count
    _unreadSub?.cancel();
    _unreadSub = ChatService().getTotalUnreadCount(userId).listen((count) {
      if (mounted) setState(() => _totalUnread = count);
    });
  }

  void _showInAppNotification(ChatNotification notification) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: InAppNotificationOverlay(
          notification: notification,
          onTap: () {
            entry.remove();
            final currentUserId = context.read<AuthCubit>().state.userId ?? '';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  currentUserId: currentUserId,
                  receiverId: notification.senderId,
                  receiverName: notification.senderName,
                  receiverImage: notification.senderPhoto.isNotEmpty
                      ? notification.senderPhoto
                      : null,
                ),
              ),
            );
          },
          onDismiss: () {
            entry.remove();
          },
        ),
      ),
    );
    overlay.insert(entry);
  }

  @override
  void dispose() {
    _homeCubit?.close();
    _notifSub?.cancel();
    _unreadSub?.cancel();
    _notificationService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);

    final currentUserId =
        context.select<AuthCubit, String?>((c) => c.state.userId) ?? '';

    if (currentUserId.isNotEmpty &&
        (_homeCubit == null || _lastUserId != currentUserId)) {
      _homeCubit?.close();
      _homeCubit = HomeCubit(currentUserId: currentUserId);
      _lastUserId = currentUserId;
      _initNotifications(currentUserId);
    }

    final List<Widget> pages = [
      if (_homeCubit != null)
        BlocProvider.value(value: _homeCubit!, child: const HomePage())
      else
        const Center(child: CircularProgressIndicator()),
      const StatusPage(),
      const CallsPage(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton: _buildFAB(primaryColor, currentUserId),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadow(context),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: _BadgeIcon(
                  icon: _selectedIndex == 0
                      ? Icons.chat_bubble_rounded
                      : Icons.chat_bubble_outline_rounded,
                  count: _totalUnread,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1
                      ? Icons.donut_large_rounded
                      : Icons.donut_large_outlined,
                  size: 24,
                ),
                label: 'Status',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2
                      ? Icons.call_rounded
                      : Icons.call_outlined,
                  size: 24,
                ),
                label: 'Calls',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 3
                      ? Icons.person_rounded
                      : Icons.person_outline_rounded,
                  size: 24,
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: primaryColor,
            unselectedItemColor: AppTheme.unselected(context),
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildFAB(Color primaryColor, String currentUserId) {
    switch (_selectedIndex) {
      case 0: // Chats - new chat
        return FloatingActionButton(
          heroTag: 'chatsFab',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewChatScreen(currentUserId: currentUserId),
              ),
            );
          },
          backgroundColor: primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.edit_square, color: Colors.white, size: 22),
        );
      case 2: // Calls - new call
        return FloatingActionButton(
          heroTag: 'callsFab',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewCallScreen(currentUserId: currentUserId),
              ),
            );
          },
          backgroundColor: primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_call, color: Colors.white, size: 22),
        );
      default:
        return null;
    }
  }
}

/// Badge icon for bottom nav showing unread count
class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const _BadgeIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: 24),
        if (count > 0)
          Positioned(
            right: -8,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppTheme.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 14),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
