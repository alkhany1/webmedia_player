import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;
  final String thumbnail;
  final bool isPlaying;
  final bool isBuffering;
  final bool showControls;
  final VoidCallback onTap;
  final VoidCallback onDoubleTapLeft;
  final VoidCallback onDoubleTapRight;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.thumbnail,
    required this.isPlaying,
    required this.isBuffering,
    required this.showControls,
    required this.onTap,
    required this.onDoubleTapLeft,
    required this.onDoubleTapRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Video/Thumbnail Display
            Positioned.fill(
              child: CustomImageWidget(
                imageUrl: thumbnail,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Video Overlay
            if (isPlaying)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.2),
                ),
              ),

            // Buffering Indicator
            if (isBuffering)
              Center(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.darkTheme.colorScheme.primary,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'جاري التحميل...',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Gesture Detection Areas
            Row(
              children: [
                // Left side - Skip backward
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    onDoubleTap: onDoubleTapLeft,
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: showControls ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'replay_10',
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '15',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Center - Play/Pause
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 80.w,
                    color: Colors.transparent,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CustomIconWidget(
                            iconName: isPlaying ? 'pause' : 'play_arrow',
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Right side - Skip forward
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    onDoubleTap: onDoubleTapRight,
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: showControls ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '15',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                CustomIconWidget(
                                  iconName: 'forward_10',
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
