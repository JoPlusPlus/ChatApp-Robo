import 'package:chatwala/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

/// Section title for settings groups
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary(context),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
