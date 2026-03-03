import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

/// Shows a search-in-chat bottom sheet overlay.
void showSearchChatSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      final searchCtrl = TextEditingController();
      return Container(
        height: MediaQuery.of(sheetCtx).size.height * 0.5,
        decoration: BoxDecoration(
          color: AppTheme.surface(sheetCtx),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider(sheetCtx),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchCtrl,
                autofocus: true,
                style: TextStyle(
                  color: AppTheme.textPrimary(sheetCtx),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search in conversation...',
                  hintStyle: TextStyle(color: AppTheme.textHint(sheetCtx)),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppTheme.textHint(sheetCtx),
                  ),
                  filled: true,
                  fillColor: AppTheme.inputFill(sheetCtx),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Type to search messages',
                  style: TextStyle(
                    color: AppTheme.textHint(sheetCtx),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
