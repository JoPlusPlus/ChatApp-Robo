import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

/// App bar title row: avatar + name + online/typing status.
class ChatAppBarTitle extends StatelessWidget {
  final String receiverName;
  final String? receiverImage;
  final VoidCallback onTap;

  const ChatAppBarTitle({
    super.key,
    required this.receiverName,
    this.receiverImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primary(context).withValues(alpha: 0.12),
            backgroundImage:
                (receiverImage != null && receiverImage!.isNotEmpty)
                ? NetworkImage(receiverImage!)
                : null,
            child: (receiverImage == null || receiverImage!.isEmpty)
                ? Text(
                    receiverName.isNotEmpty
                        ? receiverName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: AppTheme.primary(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoaded) {
                      if (state.isTyping) {
                        return Text(
                          "Typing...",
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.primary(context),
                          ),
                        );
                      }
                      if (state.isOnline) {
                        return const Text(
                          "Online",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.success,
                          ),
                        );
                      } else {
                        return Text(
                          "Offline",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textHint(context),
                          ),
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
