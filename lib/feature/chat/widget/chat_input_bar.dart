import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

/// Chat message input bar with attachment, text field, camera, and send/mic buttons.
class ChatInputBar extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onAttachTap;
  final VoidCallback onCameraTap;
  final ValueChanged<String> onSendText;
  final VoidCallback onStartRecord;

  const ChatInputBar({
    super.key,
    required this.textController,
    required this.onAttachTap,
    required this.onCameraTap,
    required this.onSendText,
    required this.onStartRecord,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: textController,
          builder: (context, value, child) {
            final hasText = value.text.trim().isNotEmpty;

            return Row(
              children: [
                // Attachment button
                GestureDetector(
                  onTap: onAttachTap,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.inputFill(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.attach_file_rounded,
                      color: AppTheme.textSecondary(context),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Text field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.inputFill(context),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            style: TextStyle(
                              color: AppTheme.textPrimary(context),
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: TextStyle(
                                color: AppTheme.textHint(context),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        if (!hasText)
                          GestureDetector(
                            onTap: onCameraTap,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: AppTheme.textHint(context),
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send or mic button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        final text = textController.text.trim();
                        if (text.isNotEmpty) {
                          onSendText(text);
                          return;
                        }
                        onStartRecord();
                      },
                      child: Icon(
                        hasText ? Icons.send_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
