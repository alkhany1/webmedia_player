import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QualitySelectorWidget extends StatelessWidget {
  final List<String> qualities;
  final String selectedQuality;
  final Function(String) onQualitySelected;
  final VoidCallback onClose;

  const QualitySelectorWidget({
    super.key,
    required this.qualities,
    required this.selectedQuality,
    required this.onQualitySelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  'جودة الفيديو',
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

          // Quality options
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(16.w),
            itemCount: qualities.length,
            itemBuilder: (context, index) {
              final quality = qualities[index];
              final isSelected = quality == selectedQuality;

              return GestureDetector(
                onTap: () {
                  onQualitySelected(quality);
                  onClose();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.darkTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.darkTheme.colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'hd',
                            color: isSelected
                                ? AppTheme.darkTheme.colorScheme.primary
                                : AppTheme
                                    .darkTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quality,
                                style: AppTheme.darkTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: isSelected
                                      ? AppTheme.darkTheme.colorScheme.primary
                                      : AppTheme
                                          .darkTheme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                _getQualityDescription(quality),
                                style: AppTheme.darkTheme.textTheme.bodySmall,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.darkTheme.colorScheme.primary,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  String _getQualityDescription(String quality) {
    switch (quality) {
      case '1080p':
        return 'جودة عالية - استهلاك بيانات أكبر';
      case '720p':
        return 'جودة متوسطة - موصى بها';
      case '480p':
        return 'جودة منخفضة - توفير البيانات';
      default:
        return 'جودة قياسية';
    }
  }
}
