import 'package:chatwala/core/model/message.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

/// Shows a search-in-chat bottom sheet that filters messages in real-time.
void showSearchChatSheet(
  BuildContext context, {
  required List<Message> messages,
  required String currentUserId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return _SearchSheetContent(
        messages: messages,
        currentUserId: currentUserId,
      );
    },
  );
}

class _SearchSheetContent extends StatefulWidget {
  final List<Message> messages;
  final String currentUserId;

  const _SearchSheetContent({
    required this.messages,
    required this.currentUserId,
  });

  @override
  State<_SearchSheetContent> createState() => _SearchSheetContentState();
}

class _SearchSheetContentState extends State<_SearchSheetContent> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Message> _results = [];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _results = widget.messages.where((msg) {
        if (msg.type == 'text' && msg.text != null) {
          return msg.text!.toLowerCase().contains(query);
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.divider(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    style: TextStyle(
                      color: AppTheme.textPrimary(context),
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search in conversation...',
                      hintStyle: TextStyle(color: AppTheme.textHint(context)),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppTheme.textHint(context),
                      ),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppTheme.textHint(context),
                                size: 18,
                              ),
                              onPressed: () => _searchCtrl.clear(),
                            )
                          : null,
                      filled: true,
                      fillColor: AppTheme.inputFill(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          // Result count
          if (query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_results.length} result${_results.length == 1 ? '' : 's'} found',
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          const Divider(height: 1),
          // Results
          Expanded(
            child: query.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: AppTheme.textHint(context),
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Type to search messages',
                          style: TextStyle(
                            color: AppTheme.textHint(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          color: AppTheme.textHint(context),
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No messages found',
                          style: TextStyle(
                            color: AppTheme.textHint(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemBuilder: (context, index) {
                      final msg = _results[index];
                      final isMe = msg.senderId == widget.currentUserId;

                      return ListTile(
                        leading: Icon(
                          isMe
                              ? Icons.arrow_forward_rounded
                              : Icons.arrow_back_rounded,
                          size: 18,
                          color: AppTheme.textHint(context),
                        ),
                        title: _highlightText(msg.text ?? '', query, context),
                        subtitle: Text(
                          '${isMe ? 'You' : 'Them'} • ${_formatTime(msg.sentAt)}',
                          style: TextStyle(
                            color: AppTheme.textHint(context),
                            fontSize: 11,
                          ),
                        ),
                        dense: true,
                        onTap: () => Navigator.pop(context),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _highlightText(String text, String query, BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 13),
      );
    }

    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lower.indexOf(query, start);
      if (idx == -1) {
        spans.add(
          TextSpan(
            text: text.substring(start),
            style: TextStyle(color: AppTheme.textPrimary(context)),
          ),
        );
        break;
      }
      if (idx > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, idx),
            style: TextStyle(color: AppTheme.textPrimary(context)),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: TextStyle(
            color: AppTheme.primary(context),
            fontWeight: FontWeight.w700,
            backgroundColor: AppTheme.primary(context).withValues(alpha: 0.15),
          ),
        ),
      );
      start = idx + query.length;
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: const TextStyle(fontSize: 13), children: spans),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
