import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
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

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: ChatBubble(message: message, isSender: isMe),
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
