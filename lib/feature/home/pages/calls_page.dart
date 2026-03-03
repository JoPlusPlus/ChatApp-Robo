import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/auth/logic/auth_cubit.dart';
import 'package:chatwala/feature/chat/screens/new_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primary(context);

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.surface(context),
            surfaceTintColor: Colors.transparent,
            elevation: 0.5,
            titleSpacing: 20,
            title: Text(
              'Calls',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary(context),
                fontSize: 26,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: false,
            actions: [
              GestureDetector(
                onTap: () {
                  AppToast.showInfo('Call search coming soon');
                },
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.inputFill(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppTheme.textSecondary(context),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(Icons.phone_outlined, size: 40, color: primary),
              ),
              const SizedBox(height: 20),
              Text(
                'No Recent Calls',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your call history will appear here.\nStart a call from any chat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary(context),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  final currentUserId =
                      context.read<AuthCubit>().state.userId ?? '';
                  if (currentUserId.isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NewCallScreen(currentUserId: currentUserId),
                    ),
                  );
                },
                icon: const Icon(Icons.add_call, size: 18),
                label: const Text('Start a Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
