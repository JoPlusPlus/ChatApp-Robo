import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/screens/call_screen.dart';
import 'package:chatwala/feature/chat/widget/quick_action.dart';
import 'package:chatwala/feature/chat/widget/report_option.dart';
import 'package:chatwala/feature/chat/widget/section_title.dart';
import 'package:chatwala/feature/chat/widget/setting_tile.dart';
import 'package:flutter/material.dart';

class ChatSettingsScreen extends StatefulWidget {
  final String receiverName;
  final String? receiverImage;
  final String receiverId;
  final bool isOnline;

  const ChatSettingsScreen({
    super.key,
    required this.receiverName,
    this.receiverImage,
    required this.receiverId,
    this.isOnline = false,
  });

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool _muteNotifications = false;
  bool _mediaAutoDownload = true;

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primary(context);
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      body: CustomScrollView(
        slivers: [
          // App bar with profile
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF2A2A4C) : primary,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2A2A4C), const Color(0xFF1A1A2E)]
                        : [primary, primary.withValues(alpha: 0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        backgroundImage:
                            widget.receiverImage != null &&
                                widget.receiverImage!.isNotEmpty
                            ? NetworkImage(widget.receiverImage!)
                            : null,
                        child:
                            widget.receiverImage == null ||
                                widget.receiverImage!.isEmpty
                            ? Text(
                                widget.receiverName.isNotEmpty
                                    ? widget.receiverName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.receiverName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isOnline
                              ? Colors.greenAccent.shade200
                              : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Quick actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickAction(
                    icon: Icons.call_rounded,
                    label: 'Audio',
                    color: primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CallScreen(
                            callerName: widget.receiverName,
                            callerImage: widget.receiverImage,
                            isVideo: false,
                          ),
                        ),
                      );
                    },
                  ),
                  QuickAction(
                    icon: Icons.videocam_rounded,
                    label: 'Video',
                    color: primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CallScreen(
                            callerName: widget.receiverName,
                            callerImage: widget.receiverImage,
                            isVideo: true,
                          ),
                        ),
                      );
                    },
                  ),
                  QuickAction(
                    icon: Icons.search_rounded,
                    label: 'Search',
                    color: primary,
                    onTap: () {
                      AppToast.showInfo('Search in chat coming soon');
                    },
                  ),
                ],
              ),
            ),
          ),

          // Settings sections
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionTitle('Notifications'),
                SettingTile(
                  icon: Icons.notifications_off_outlined,
                  title: 'Mute Notifications',
                  trailing: Switch.adaptive(
                    value: _muteNotifications,
                    onChanged: (v) => setState(() => _muteNotifications = v),
                  ),
                ),
                const SizedBox(height: 8),
                SettingTile(
                  icon: Icons.music_note_rounded,
                  title: 'Custom Notification Tone',
                  subtitle: 'Default',
                  onTap: () => _showNotificationToneDialog(context),
                ),
                const SizedBox(height: 20),

                SectionTitle('Media & Storage'),
                SettingTile(
                  icon: Icons.download_rounded,
                  title: 'Media Auto-Download',
                  trailing: Switch.adaptive(
                    value: _mediaAutoDownload,
                    onChanged: (v) => setState(() => _mediaAutoDownload = v),
                  ),
                ),
                const SizedBox(height: 8),
                SettingTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Media, Links and Docs',
                  subtitle: 'View shared media',
                  onTap: () {
                    AppToast.showInfo('Shared media viewer coming soon');
                  },
                ),
                const SizedBox(height: 20),

                SectionTitle('Privacy'),
                SettingTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Encryption',
                  subtitle: 'Messages are end-to-end encrypted',
                  onTap: () => _showEncryptionDialog(context),
                ),
                const SizedBox(height: 8),
                SettingTile(
                  icon: Icons.timer_outlined,
                  title: 'Disappearing Messages',
                  subtitle: 'Off',
                  onTap: () => _showDisappearingMessagesDialog(context),
                ),
                const SizedBox(height: 20),

                SectionTitle('Actions'),
                SettingTile(
                  icon: Icons.block_rounded,
                  title: 'Block ${widget.receiverName}',
                  titleColor: AppTheme.error,
                  onTap: () => _showBlockDialog(context),
                ),
                const SizedBox(height: 8),
                SettingTile(
                  icon: Icons.thumb_down_outlined,
                  title: 'Report ${widget.receiverName}',
                  titleColor: AppTheme.error,
                  onTap: () => _showReportDialog(context),
                ),
                const SizedBox(height: 8),
                SettingTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Clear Chat',
                  titleColor: AppTheme.error,
                  onTap: () => _showClearChatDialog(context),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Block Contact'),
        content: Text(
          'Are you sure you want to block ${widget.receiverName}? '
          'They will no longer be able to send you messages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Chat'),
        content: const Text(
          'Are you sure you want to clear all messages in this chat? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AppToast.showSuccess('Chat cleared');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Report ${widget.receiverName}',
          style: TextStyle(color: AppTheme.textPrimary(ctx)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you reporting this contact?',
              style: TextStyle(
                color: AppTheme.textSecondary(ctx),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ReportOption(
              label: 'Spam',
              onTap: () {
                Navigator.pop(ctx);
                AppToast.showSuccess('Report submitted. Thank you.');
              },
            ),
            ReportOption(
              label: 'Harassment',
              onTap: () {
                Navigator.pop(ctx);
                AppToast.showSuccess('Report submitted. Thank you.');
              },
            ),
            ReportOption(
              label: 'Inappropriate content',
              onTap: () {
                Navigator.pop(ctx);
                AppToast.showSuccess('Report submitted. Thank you.');
              },
            ),
            ReportOption(
              label: 'Other',
              onTap: () {
                Navigator.pop(ctx);
                AppToast.showSuccess('Report submitted. Thank you.');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary(ctx)),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationToneDialog(BuildContext context) {
    final tones = ['Default', 'Chime', 'Ding', 'Pop', 'Swoosh', 'None'];
    showDialog(
      context: context,
      builder: (ctx) {
        String selected = 'Default';
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: AppTheme.surface(ctx),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Notification Tone',
              style: TextStyle(color: AppTheme.textPrimary(ctx)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: tones
                  .map(
                    (tone) => InkWell(
                      onTap: () => setDialogState(() => selected = tone),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selected == tone
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: selected == tone
                                  ? AppTheme.primary(ctx)
                                  : AppTheme.textHint(ctx),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              tone,
                              style: TextStyle(
                                color: AppTheme.textPrimary(ctx),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.textSecondary(ctx)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  AppToast.showSuccess('Tone set to $selected');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary(ctx),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEncryptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.lock_rounded, color: AppTheme.primary(ctx), size: 22),
            const SizedBox(width: 10),
            Text(
              'Encryption',
              style: TextStyle(color: AppTheme.textPrimary(ctx)),
            ),
          ],
        ),
        content: Text(
          'Messages and calls are end-to-end encrypted. '
          'No one outside of this chat, not even ChatWala, '
          'can read or listen to them.',
          style: TextStyle(
            color: AppTheme.textSecondary(ctx),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary(ctx),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDisappearingMessagesDialog(BuildContext context) {
    final options = ['Off', '24 hours', '7 days', '90 days'];
    showDialog(
      context: context,
      builder: (ctx) {
        String selected = 'Off';
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: AppTheme.surface(ctx),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Disappearing Messages',
              style: TextStyle(color: AppTheme.textPrimary(ctx)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New messages will disappear after the selected duration.',
                  style: TextStyle(
                    color: AppTheme.textSecondary(ctx),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map(
                  (opt) => InkWell(
                    onTap: () => setDialogState(() => selected = opt),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected == opt
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: selected == opt
                                ? AppTheme.primary(ctx)
                                : AppTheme.textHint(ctx),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            opt,
                            style: TextStyle(
                              color: AppTheme.textPrimary(ctx),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.textSecondary(ctx)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  AppToast.showSuccess('Disappearing messages: $selected');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary(ctx),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
