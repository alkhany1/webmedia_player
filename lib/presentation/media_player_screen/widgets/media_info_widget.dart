import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MediaInfoWidget extends StatefulWidget {
  final String title;
  final String description;
  final String views;
  final String uploadDate;
  final String channel;

  const MediaInfoWidget({
    super.key,
    required this.title,
    required this.description,
    required this.views,
    required this.uploadDate,
    required this.channel,
  });

  @override
  State<MediaInfoWidget> createState() => _MediaInfoWidgetState();
}

class _MediaInfoWidgetState extends State<MediaInfoWidget> {
  bool _isDescriptionExpanded = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isSubscribed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.title,
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textDirection: TextDirection.rtl,
        ),

        SizedBox(height: 12.h),

        // Channel info and actions
        Row(
          children: [
            // Channel avatar
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  widget.channel.substring(0, 1),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Channel name and subscriber count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.channel,
                    style: AppTheme.darkTheme.textTheme.titleMedium,
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    '12.5K مشترك',
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),

            // Subscribe button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isSubscribed = !_isSubscribed;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSubscribed
                    ? AppTheme.darkTheme.colorScheme.surfaceContainerHigh
                    : AppTheme.darkTheme.colorScheme.primary,
                foregroundColor: _isSubscribed
                    ? AppTheme.darkTheme.colorScheme.onSurface
                    : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _isSubscribed ? 'مشترك' : 'اشتراك',
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Video stats and actions
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Stats row
              Row(
                children: [
                  Text(
                    '${widget.views} مشاهدة',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _formatDate(widget.uploadDate),
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: _isLiked ? 'thumb_up' : 'thumb_up_outlined',
                    label: 'إعجاب',
                    isActive: _isLiked,
                    onTap: () => setState(() {
                      _isLiked = !_isLiked;
                      if (_isLiked) _isDisliked = false;
                    }),
                  ),
                  _buildActionButton(
                    icon: _isDisliked ? 'thumb_down' : 'thumb_down_outlined',
                    label: 'عدم إعجاب',
                    isActive: _isDisliked,
                    onTap: () => setState(() {
                      _isDisliked = !_isDisliked;
                      if (_isDisliked) _isLiked = false;
                    }),
                  ),
                  _buildActionButton(
                    icon: 'share',
                    label: 'مشاركة',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم نسخ رابط المقطع'),
                          backgroundColor:
                              AppTheme.darkTheme.colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: 'bookmark_border',
                    label: 'حفظ',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم حفظ المقطع'),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Description
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.description,
                style: AppTheme.darkTheme.textTheme.bodyMedium,
                textDirection: TextDirection.rtl,
                maxLines: _isDescriptionExpanded ? null : 3,
                overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                },
                child: Text(
                  _isDescriptionExpanded ? 'عرض أقل' : 'عرض المزيد',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.darkTheme.colorScheme.primary
                      .withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: isActive
                  ? AppTheme.darkTheme.colorScheme.primary
                  : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: isActive
                  ? AppTheme.darkTheme.colorScheme.primary
                  : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 30) {
        return 'منذ ${(difference.inDays / 30).floor()} شهر';
      } else if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ساعة';
      } else {
        return 'منذ ${difference.inMinutes} دقيقة';
      }
    } catch (e) {
      return dateString;
    }
  }
}
