import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlaylistPanelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> playlist;
  final Function(Map<String, dynamic>) onItemTap;
  final VoidCallback onClose;

  const PlaylistPanelWidget({
    super.key,
    required this.playlist,
    required this.onItemTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.darkTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة التشغيل',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                  textDirection: TextDirection.rtl,
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.darkTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Playlist items
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: playlist.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = playlist[index];
                final isPlaying = item["isPlaying"] as bool;

                return GestureDetector(
                  onTap: () => onItemTap(item),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? AppTheme.darkTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                          : AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isPlaying
                            ? AppTheme.darkTheme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Thumbnail
                        Container(
                          width: 60.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                AppTheme.darkTheme.colorScheme.surfaceContainer,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl: item["thumbnail"] as String,
                              width: 60.w,
                              height: 45.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"] as String,
                                style: AppTheme.darkTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: isPlaying
                                      ? AppTheme.darkTheme.colorScheme.primary
                                      : AppTheme
                                          .darkTheme.colorScheme.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item["duration"] as String,
                                style: AppTheme.darkTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),

                        // Play indicator or index
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? AppTheme.darkTheme.colorScheme.primary
                                : AppTheme
                                    .darkTheme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: isPlaying
                                ? CustomIconWidget(
                                    iconName: 'play_arrow',
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: AppTheme.darkTheme.colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
