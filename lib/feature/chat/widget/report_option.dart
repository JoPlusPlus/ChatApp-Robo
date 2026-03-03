import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

/// Report reason list item
class ReportOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ReportOption({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Icon(
              Icons.radio_button_unchecked,
              size: 18,
              color: AppTheme.textHint(context),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
