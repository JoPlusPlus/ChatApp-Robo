import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/core/model/message.dart';
import 'package:chatwala/feature/chat/widget/chatbubbles.dart';
import 'package:flutter/material.dart';

/// Image message bubble with full-screen preview on tap
class ImageBubble extends StatelessWidget {
  final Message message;
  final bool isSender;

  const ImageBubble({super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);

    return GestureDetector(
      onTap: () {
        if (message.imageUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenImage(
                imageUrl: message.imageUrl!,
                heroTag: message.id,
              ),
            ),
          );
        }
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: isSender ? primaryColor : AppTheme.card(context),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(18),
            bottomRight: const Radius.circular(18),
            topLeft: Radius.circular(isSender ? 18 : 4),
            topRight: Radius.circular(isSender ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadow(context),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 18 : 4),
            topRight: Radius.circular(isSender ? 4 : 18),
            bottomLeft: const Radius.circular(18),
            bottomRight: const Radius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Hero(
                tag: 'img_${message.id}',
                child: Image.network(
                  message.imageUrl ?? '',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                          color: isSender ? Colors.white : primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: isSender
                            ? Colors.white70
                            : AppTheme.textHint(context),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${message.sentAt.hour.toString().padLeft(2, '0')}:"
                      "${message.sentAt.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 10,
                        color: isSender
                            ? Colors.white.withValues(alpha: 0.6)
                            : AppTheme.textHint(context),
                      ),
                    ),
                    if (isSender) ...[
                      const SizedBox(width: 3),
                      MessageStatusIcon(
                        status: message.status,
                        isSender: isSender,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen image viewer
class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Hero(
            tag: 'img_$heroTag',
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_rounded,
                color: Colors.white54,
                size: 64,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
