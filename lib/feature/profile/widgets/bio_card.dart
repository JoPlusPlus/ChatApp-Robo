import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/auth/logic/auth_state.dart';
import 'package:flutter/material.dart';

class BioCard extends StatelessWidget {
  final AuthState authState;
  final VoidCallback onEditBio;

  const BioCard({super.key, required this.authState, required this.onEditBio});

  @override
  Widget build(BuildContext context) {
    final hasBio = authState.bio != null && authState.bio!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow(context),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppTheme.primary(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary(context),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onEditBio,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: AppTheme.primary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasBio ? authState.bio! : 'Tap edit to add a bio...',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontStyle: hasBio ? FontStyle.normal : FontStyle.italic,
              color: hasBio
                  ? AppTheme.textPrimary(context)
                  : AppTheme.textHint(context),
            ),
          ),
        ],
      ),
    );
  }
}
