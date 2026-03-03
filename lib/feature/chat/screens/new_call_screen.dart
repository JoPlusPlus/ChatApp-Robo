import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/data/chatservice.dart';
import 'package:chatwala/feature/chat/screens/call_screen.dart';
import 'package:flutter/material.dart';


class NewCallScreen extends StatefulWidget {
  final String currentUserId;

  const NewCallScreen({super.key, required this.currentUserId});

  @override
  State<NewCallScreen> createState() => _NewCallScreenState();
}

class _NewCallScreenState extends State<NewCallScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startCall(
    BuildContext context, {
    required String name,
    String? photo,
    required bool isVideo,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CallScreen(callerName: name, callerImage: photo, isVideo: isVideo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primary(context);

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      appBar: AppBar(
        backgroundColor: AppTheme.surface(context),
        foregroundColor: AppTheme.textPrimary(context),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Call',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.inputFill(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (q) => setState(() => _searchQuery = q),
                style: TextStyle(
                  color: AppTheme.textPrimary(context),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  hintStyle: TextStyle(
                    color: AppTheme.textHint(context),
                    fontSize: 14,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppTheme.textHint(context),
                      size: 20,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),

          // User list
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: ChatService().getAllUsers(widget.currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          size: 56,
                          color: AppTheme.textHint(context),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No contacts found',
                          style: TextStyle(
                            color: AppTheme.textSecondary(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var users = snapshot.data!;
                if (_searchQuery.isNotEmpty) {
                  final q = _searchQuery.toLowerCase();
                  users = users
                      .where(
                        (u) =>
                            (u['name'] ?? '').toString().toLowerCase().contains(
                              q,
                            ) ||
                            (u['email'] ?? '')
                                .toString()
                                .toLowerCase()
                                .contains(q),
                      )
                      .toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final name = user['name'] ?? 'Unknown';
                    final photo = user['photoUrl'] ?? '';
                    final isOnline = user['isOnline'] ?? false;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: AppTheme.card(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    backgroundImage: photo.isNotEmpty
                                        ? NetworkImage(photo)
                                        : null,
                                    child: photo.isEmpty
                                        ? Text(
                                            name.isNotEmpty
                                                ? name[0].toUpperCase()
                                                : '?',
                                            style: TextStyle(
                                              color: primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          )
                                        : null,
                                  ),
                                  if (isOnline)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppTheme.success,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.card(context),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: AppTheme.textPrimary(context),
                                  ),
                                ),
                              ),
                              // Audio call button
                              IconButton(
                                onPressed: () => _startCall(
                                  context,
                                  name: name,
                                  photo: photo.isNotEmpty ? photo : null,
                                  isVideo: false,
                                ),
                                icon: Icon(
                                  Icons.call_rounded,
                                  color: primary,
                                  size: 22,
                                ),
                              ),
                              // Video call button
                              IconButton(
                                onPressed: () => _startCall(
                                  context,
                                  name: name,
                                  photo: photo.isNotEmpty ? photo : null,
                                  isVideo: true,
                                ),
                                icon: Icon(
                                  Icons.videocam_rounded,
                                  color: primary,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
