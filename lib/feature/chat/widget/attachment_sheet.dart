import 'package:chatwala/core/app_toast.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/chat/widget/attach_option.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Shows the attachment bottom sheet with camera, gallery, document, location options.
void showAttachmentSheet({
  required BuildContext context,
  required void Function(ImageSource source) onPickImage,
}) {
  final primary = AppTheme.primary(context);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) => Container(
      decoration: BoxDecoration(
        color: AppTheme.surface(sheetCtx),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider(sheetCtx),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Share Content',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary(sheetCtx),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AttachOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: primary,
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      onPickImage(ImageSource.camera);
                    },
                  ),
                  AttachOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: AppTheme.info,
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      onPickImage(ImageSource.gallery);
                    },
                  ),
                  AttachOption(
                    icon: Icons.insert_drive_file_rounded,
                    label: 'Document',
                    color: AppTheme.success,
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      AppToast.showInfo('Document sharing coming soon');
                    },
                  ),
                  AttachOption(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      AppToast.showInfo('Location sharing coming soon');
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
}
