import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentUrlsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentUrls;
  final Function(String) onUrlSelected;
  final Function(int) onUrlRemoved;

  const RecentUrlsWidget({
    super.key,
    required this.recentUrls,
    required this.onUrlSelected,
    required this.onUrlRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...recentUrls.asMap().entries.map((entry) {
          final index = entry.key;
          final urlData = entry.value;
          return _buildRecentUrlChip(context, urlData, index);
        }),
      ],
    );
  }

  Widget _buildRecentUrlChip(
      BuildContext context, Map<String, dynamic> urlData, int index) {
    final String url = urlData["url"] as String;
    final String title = urlData["title"] as String;
    final DateTime timestamp = urlData["timestamp"] as DateTime;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: AppTheme.darkTheme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onUrlSelected(url),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'link',
                    color: AppTheme.darkTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.darkTheme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _formatTimestamp(timestamp),
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onUrlRemoved(index),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    } else {
      return 'الآن';
    }
  }
}
