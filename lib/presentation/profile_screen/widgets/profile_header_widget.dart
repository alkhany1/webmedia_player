import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentColor,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: userData["avatar"] != null
                      ? CustomImageWidget(
                          imageUrl: userData["avatar"] as String,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppTheme
                              .darkTheme.colorScheme.surfaceContainerHigh,
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.darkTheme.colorScheme.onSurface,
                            size: 10.w,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.darkTheme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: Colors.white,
                    size: 3.w,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // User Name
          Text(
            userData["name"] as String? ?? 'المستخدم',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 0.5.h),

          // User Email
          Text(
            userData["email"] as String? ?? 'user@example.com',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 0.5.h),

          // Join Date
          Text(
            'عضو منذ ${userData["joinDate"] as String? ?? "2023"}',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditPressed,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.accentColor,
                size: 18,
              ),
              label: Text('تعديل الملف الشخصي'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
