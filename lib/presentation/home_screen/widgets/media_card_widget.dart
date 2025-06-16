import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MediaCardWidget extends StatelessWidget {
  final Map<String, dynamic> media;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const MediaCardWidget({
    super.key,
    required this.media,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomImageWidget(
                    imageUrl: media['thumbnail'] as String,
                    width: double.infinity,
                    height: 25.h,
                    fit: BoxFit.cover,
                  ),
                ),

                // Duration overlay
                Positioned(
                  bottom: 2.w,
                  left: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      media['duration'] as String,
                      style: AppTheme.mediaDataTextStyle(
                          isLight: false, fontSize: 12),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),

                // Quality badge
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getQualityColor(media['quality'] as String),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      media['quality'] as String,
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Type icon
                Positioned(
                  top: 2.w,
                  left: 2.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomIconWidget(
                      iconName: _getTypeIcon(media['type'] as String),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            // Content info
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    media['title'] as String,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),

                  SizedBox(height: 1.h),

                  // Views and upload date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'visibility',
                            color:
                                AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            media['views'] as String,
                            style: AppTheme.darkTheme.textTheme.bodySmall,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Text(
                        media['uploadDate'] as String,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case '4k':
        return AppTheme.accentColor;
      case 'hd':
        return AppTheme.successColor;
      case 'hq':
        return Colors.blue;
      default:
        return AppTheme.darkTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return 'play_circle_filled';
      case 'audio':
        return 'music_note';
      case 'live':
        return 'live_tv';
      default:
        return 'play_arrow';
    }
  }
}
