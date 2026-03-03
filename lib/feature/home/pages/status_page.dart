import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/home/widgets/menu_tile.dart';
import 'package:chatwala/feature/home/widgets/status_option.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  void _pickStatusImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surface(ctx),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.divider(ctx),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Add Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary(ctx),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Share a photo or text status',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary(ctx),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatusOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: AppTheme.primary(ctx),
                      onTap: () => Navigator.pop(ctx, ImageSource.camera),
                    ),
                    StatusOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      color: AppTheme.info,
                      onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                    ),
                    StatusOption(
                      icon: Icons.text_fields_rounded,
                      label: 'Text',
                      color: AppTheme.success,
                      onTap: () {
                        Navigator.pop(ctx);
                        AppToast.showInfo('Text status coming soon');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        AppToast.showInfo('Status photo captured! Upload coming soon.');
      }
    } catch (e) {
      AppToast.showError('Failed to capture status image');
    }
  }

  void _showMoreMenu(BuildContext context) {
    final primary = AppTheme.primary(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surface(ctx),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.divider(ctx),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                MenuTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Status Privacy',
                  subtitle: 'Control who sees your status',
                  color: primary,
                  onTap: () {
                    Navigator.pop(ctx);
                    AppToast.showInfo('Status privacy settings coming soon');
                  },
                ),
                const SizedBox(height: 8),
                MenuTile(
                  icon: Icons.settings_outlined,
                  title: 'Status Settings',
                  subtitle: 'Manage status preferences',
                  color: primary,
                  onTap: () {
                    Navigator.pop(ctx);
                    AppToast.showInfo('Status settings coming soon');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
              'Status',
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
                onTap: () => _showMoreMenu(context),
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.inputFill(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppTheme.textSecondary(context),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            // My Status
            GestureDetector(
              onTap: () => _pickStatusImage(context),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.card(context),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadow(context),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: primary.withValues(alpha: 0.12),
                          child: Icon(Icons.person, color: primary, size: 28),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.card(context),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppTheme.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Tap to add status update',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recent updates section
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Recent Updates',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary(context),
                ),
              ),
            ),

            // Placeholder for no statuses
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.card(context),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 48,
                    color: AppTheme.textHint(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Status Updates',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Status updates from your contacts will show up here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'statusFab',
        onPressed: () => _pickStatusImage(context),
        backgroundColor: primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
      ),
    );
  }
}
