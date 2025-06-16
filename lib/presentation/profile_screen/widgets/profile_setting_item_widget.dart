import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSettingItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const ProfileSettingItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        child: Row(
          children: [
            // Icon
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: titleColor == AppTheme.errorDark
                    ? AppTheme.errorDark.withValues(alpha: 0.1)
                    : AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: titleColor ?? AppTheme.accentColor,
                  size: 5.w,
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: titleColor ??
                          AppTheme.darkTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.2.h),
                    Text(
                      subtitle!,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing Widget or Arrow
            trailing ??
                (onTap != null
                    ? CustomIconWidget(
                        iconName: 'arrow_forward_ios',
                        color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      )
                    : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
