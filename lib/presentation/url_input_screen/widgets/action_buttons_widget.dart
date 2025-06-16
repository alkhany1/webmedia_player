import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final bool isValidUrl;
  final bool isLoading;
  final VoidCallback onStreamNow;
  final VoidCallback onAddToQueue;

  const ActionButtonsWidget({
    super.key,
    required this.isValidUrl,
    required this.isLoading,
    required this.onStreamNow,
    required this.onAddToQueue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary Stream Now Button
        SizedBox(
          height: 6.h,
          child: ElevatedButton(
            onPressed: isValidUrl && !isLoading ? onStreamNow : null,
            style: AppTheme.darkTheme.elevatedButtonTheme.style?.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppTheme.darkTheme.colorScheme.surfaceContainer;
                }
                return AppTheme.darkTheme.colorScheme.primary;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppTheme.darkTheme.colorScheme.onSurfaceVariant;
                }
                return Colors.white;
              }),
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'جاري التحميل...',
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'play_circle_filled',
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'تشغيل الآن',
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        SizedBox(height: 2.h),

        // Secondary Add to Queue Button
        SizedBox(
          height: 6.h,
          child: OutlinedButton(
            onPressed: isValidUrl && !isLoading ? onAddToQueue : null,
            style: AppTheme.darkTheme.outlinedButtonTheme.style?.copyWith(
              side: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return BorderSide(
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                    width: 1,
                  );
                }
                return BorderSide(
                  color: AppTheme.darkTheme.colorScheme.primary,
                  width: 1,
                );
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppTheme.darkTheme.colorScheme.onSurfaceVariant;
                }
                return AppTheme.darkTheme.colorScheme.primary;
              }),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'playlist_add',
                  color: isValidUrl && !isLoading
                      ? AppTheme.darkTheme.colorScheme.primary
                      : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'إضافة إلى قائمة الانتظار',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: isValidUrl && !isLoading
                        ? AppTheme.darkTheme.colorScheme.primary
                        : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Helper text
        Center(
          child: Text(
            isValidUrl ? 'الرابط جاهز للتشغيل' : 'يرجى إدخال رابط kool.to صحيح',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: isValidUrl
                  ? AppTheme.successColor
                  : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
