import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'chatbubbles.dart';

/// Displays the chat message list with loading, error, empty, and loaded states.
class ChatMessageList extends StatelessWidget {
  final String currentUserId;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppTheme.primary(context)),
          );
        }

        if (state is ChatError) {
          return Center(
            child: Text(
              "Error: ${state.message}",
              style: const TextStyle(color: AppTheme.error),
            ),
          );
        }

        if (state is ChatLoaded) {
          if (state.messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppTheme.textHint(context),
                    size: 56,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No messages yet...",
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Say hello! 👋",
                    style: TextStyle(
                      color: AppTheme.textHint(context),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: scrollController,
            reverse: true,
            padding: const EdgeInsets.all(12),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[state.messages.length - 1 - index];
              final isMe = message.senderId == currentUserId;

              return GestureDetector(
                onLongPress: () => _showMessageOptions(
                  context,
                  message.id,
                  isMe,
                  message.type == 'text' ? message.text : null,
                ),
                child: Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ChatBubble(message: message, isSender: isMe),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  static void _showMessageOptions(
    BuildContext context,
    String messageId,
    bool isMe,
    String? textToCopy,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surface(sheetCtx),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.divider(sheetCtx),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (textToCopy != null && textToCopy.isNotEmpty)
                  ListTile(
                    leading: Icon(
                      Icons.copy_rounded,
                      color: AppTheme.textSecondary(sheetCtx),
                    ),
                    title: Text(
                      'Copy',
                      style: TextStyle(color: AppTheme.textPrimary(sheetCtx)),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: textToCopy));
                      Navigator.pop(sheetCtx);
                      AppToast.showSuccess('Copied to clipboard');
                    },
                  ),
                if (isMe)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppTheme.error,
                    ),
                    title: const Text(
                      'Delete message',
                      style: TextStyle(color: AppTheme.error),
                    ),
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      _confirmDeleteMessage(context, messageId);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _confirmDeleteMessage(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChatCubit>().deleteMessage(messageId);
              Navigator.pop(dialogCtx);
              AppToast.showSuccess('Message deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
