import 'package:chatwala/core/app_router.dart';
import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/theme_cubit.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/auth/logic/auth_cubit.dart';
import 'package:chatwala/feature/auth/logic/auth_state.dart';
import 'package:chatwala/feature/profile/widgets/profile_header.dart';
import 'package:chatwala/feature/profile/widgets/bio_card.dart';
import 'package:chatwala/feature/profile/widgets/stats_card.dart';
import 'package:chatwala/feature/profile/widgets/setting_card.dart';
import 'package:chatwala/feature/profile/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  late TextEditingController _bioController;
  late TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
    _displayNameController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authState = context.read<AuthCubit>().state;
    _bioController.text = authState.bio ?? '';
    _displayNameController.text = authState.displayName ?? '';
    context.read<AuthCubit>().loadBio();
  }

  // ─── Shared Dialog Helpers ───────────────────────────────
  Widget _dialogHandle(BuildContext ctx) => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.divider(ctx),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  BoxDecoration _dialogSheetDecor(BuildContext ctx) => BoxDecoration(
    color: AppTheme.surface(ctx),
    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
    border: Border(
      top: BorderSide(color: AppTheme.divider(ctx), width: 0.5),
      left: BorderSide(color: AppTheme.divider(ctx), width: 0.5),
      right: BorderSide(color: AppTheme.divider(ctx), width: 0.5),
    ),
    boxShadow: [
      BoxShadow(
        color: AppTheme.shadow(ctx),
        blurRadius: 20,
        offset: const Offset(0, -4),
      ),
    ],
  );

  Widget _sheetOption({
    required BuildContext ctx,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.divider(ctx)),
            borderRadius: BorderRadius.circular(14),
            color: AppTheme.card(ctx),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary(ctx),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary(ctx),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textHint(ctx),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dialogInputDecoration(
    BuildContext ctx, {
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppTheme.textHint(ctx),
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: Icon(icon, color: AppTheme.textHint(ctx), size: 20),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: AppTheme.inputFill(ctx),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.divider(ctx)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.primary(ctx), width: 1.5),
      ),
      counterStyle: TextStyle(color: AppTheme.textHint(ctx), fontSize: 11),
    );
  }

  Widget _dialogCancelButton(BuildContext ctx) => Expanded(
    child: OutlinedButton(
      onPressed: () => Navigator.pop(ctx),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textSecondary(ctx),
        side: BorderSide(color: AppTheme.divider(ctx)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
  );

  Widget _dialogPrimaryButton(
    BuildContext ctx, {
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) => Expanded(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppTheme.primary(ctx),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ),
  );

  // ─── Image Picker ───────────────────────────────────────
  Future<void> _pickProfileImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: _dialogSheetDecor(ctx),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogHandle(ctx),
                const SizedBox(height: 20),
                Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary(ctx),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose how you\'d like to update your photo',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary(ctx),
                  ),
                ),
                const SizedBox(height: 22),
                _sheetOption(
                  ctx: ctx,
                  icon: Icons.camera_alt_rounded,
                  iconColor: AppTheme.primary(ctx),
                  title: 'Camera',
                  subtitle: 'Take a new photo',
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
                const SizedBox(height: 10),
                _sheetOption(
                  ctx: ctx,
                  icon: Icons.photo_library_rounded,
                  iconColor: AppTheme.info,
                  title: 'Gallery',
                  subtitle: 'Choose from your library',
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary(ctx),
                      side: BorderSide(color: AppTheme.divider(ctx)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (image != null && mounted) {
        AppToast.showSuccess('Uploading profile picture...');
        await context.read<AuthCubit>().uploadProfileImage(image.path);
        if (mounted) {
          AppToast.showSuccess('Profile picture updated!');
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError('Failed to pick image: $e');
      }
    }
  }

  // ─── Edit Bio Dialog ────────────────────────────────────
  void _showEditBioDialog() {
    final ctx = context;
    showDialog(
      context: ctx,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: AppTheme.divider(ctx), width: 0.5),
        ),
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.primary(ctx).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      color: AppTheme.primary(ctx),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Bio',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary(ctx),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tell others about yourself',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary(ctx),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Input
              TextField(
                controller: _bioController,
                maxLines: 4,
                maxLength: 150,
                style: TextStyle(
                  color: AppTheme.textPrimary(ctx),
                  fontSize: 14,
                  height: 1.5,
                ),
                decoration: _dialogInputDecoration(
                  ctx,
                  hint: 'Write something about yourself...',
                  icon: Icons.format_quote_rounded,
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              Row(
                children: [
                  _dialogCancelButton(ctx),
                  const SizedBox(width: 12),
                  _dialogPrimaryButton(
                    ctx,
                    label: 'Save Bio',
                    onPressed: () {
                      ctx.read<AuthCubit>().updateBio(_bioController.text);
                      Navigator.pop(ctx);
                      AppToast.showSuccess('Bio updated');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Edit Name Dialog ───────────────────────────────────
  void _showEditNameDialog() {
    final ctx = context;
    showDialog(
      context: ctx,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: AppTheme.divider(ctx), width: 0.5),
        ),
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.primary(ctx).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: AppTheme.primary(ctx),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Display Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary(ctx),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'How others will see you',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary(ctx),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Input
              TextField(
                controller: _displayNameController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                  color: AppTheme.textPrimary(ctx),
                  fontSize: 14,
                ),
                decoration: _dialogInputDecoration(
                  ctx,
                  hint: 'Enter your name',
                  icon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  _dialogCancelButton(ctx),
                  const SizedBox(width: 12),
                  _dialogPrimaryButton(
                    ctx,
                    label: 'Save Name',
                    onPressed: () {
                      ctx.read<AuthCubit>().updateProfile(
                        displayName: _displayNameController.text,
                      );
                      Navigator.pop(ctx);
                      AppToast.showSuccess('Name updated');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Logout Dialog ──────────────────────────────────────
  void _showLogoutDialog() {
    final ctx = context;
    showDialog(
      context: ctx,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppTheme.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: AppTheme.divider(ctx), width: 0.5),
        ),
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppTheme.error,
                  size: 26,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary(ctx),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Are you sure you want to log out?\nYou\'ll need to sign in again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary(ctx),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),

              // Divider
              Divider(color: AppTheme.divider(ctx), height: 1),
              const SizedBox(height: 20),

              // Actions
              Row(
                children: [
                  _dialogCancelButton(dialogContext),
                  const SizedBox(width: 12),
                  _dialogPrimaryButton(
                    dialogContext,
                    label: 'Logout',
                    color: AppTheme.error,
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      ctx.read<AuthCubit>().signOut();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.loginSignup,
            (route) => false,
          );
        } else if (state.status == AuthStatus.error) {
          AppToast.showError(state.errorMessage ?? 'An error occurred');
        }
      },
      child: Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return CustomScrollView(
              slivers: [
                // ── Gradient Header ──
                SliverToBoxAdapter(
                  child: ProfileHeader(
                    authState: authState,
                    onPickImage: _pickProfileImage,
                    onEditName: _showEditNameDialog,
                  ),
                ),

                // ── Body Content ──
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 24),

                      // Bio Card
                      BioCard(
                        authState: authState,
                        onEditBio: _showEditBioDialog,
                      ),

                      const SizedBox(height: 20),

                      // Stats Row
                      ProfileStatsRow(authState: authState),

                      const SizedBox(height: 28),

                      // Settings Section Title
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary(context),
                          ),
                        ),
                      ),

                      // Notifications
                      SettingCard(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage notification preferences',
                        iconColor: AppTheme.info,
                        onTap: () {},
                      ),

                      const SizedBox(height: 10),

                      // Privacy
                      SettingCard(
                        icon: Icons.lock_outline,
                        title: 'Privacy',
                        subtitle: 'Control your privacy settings',
                        iconColor: AppTheme.success,
                        onTap: () {},
                      ),

                      const SizedBox(height: 10),

                      // Appearance
                      BlocBuilder<ThemeCubit, bool>(
                        builder: (context, isDarkMode) {
                          return SettingCard(
                            icon: isDarkMode
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            title: 'Appearance',
                            subtitle: isDarkMode ? 'Dark Mode' : 'Light Mode',
                            iconColor: AppTheme.warning,
                            onTap: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                            trailing: Switch.adaptive(
                              value: isDarkMode,
                              onChanged: (_) {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Logout
                      LogoutButton(onPressed: _showLogoutDialog),
                    ]),
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
