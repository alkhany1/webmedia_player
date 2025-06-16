import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MediaControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final double currentPosition;
  final double totalDuration;
  final double volume;
  final VoidCallback onPlayPause;
  final VoidCallback onSkipBackward;
  final VoidCallback onSkipForward;
  final Function(double) onSeek;
  final Function(double) onVolumeChange;
  final VoidCallback onFullscreen;
  final VoidCallback onPlaylist;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onQualitySelector;
  final String Function(double) formatDuration;
  final bool isFullscreen;

  const MediaControlsWidget({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.volume,
    required this.onPlayPause,
    required this.onSkipBackward,
    required this.onSkipForward,
    required this.onSeek,
    required this.onVolumeChange,
    required this.onFullscreen,
    required this.onPlaylist,
    required this.onShare,
    required this.onDownload,
    required this.onQualitySelector,
    required this.formatDuration,
    this.isFullscreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFullscreen) ...[
            // Fullscreen top controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onQualitySelector,
                      icon: CustomIconWidget(
                        iconName: 'hd',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: onShare,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],

          // Main control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onSkipBackward,
                icon: CustomIconWidget(
                  iconName: 'replay_10',
                  color: Colors.white,
                  size: isFullscreen ? 32 : 28,
                ),
              ),
              SizedBox(width: 20.w),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: onPlayPause,
                  icon: CustomIconWidget(
                    iconName: isPlaying ? 'pause' : 'play_arrow',
                    color: Colors.white,
                    size: isFullscreen ? 36 : 32,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              IconButton(
                onPressed: onSkipForward,
                icon: CustomIconWidget(
                  iconName: 'forward_10',
                  color: Colors.white,
                  size: isFullscreen ? 32 : 28,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Progress bar
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.darkTheme.colorScheme.primary,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                  thumbColor: AppTheme.darkTheme.colorScheme.primary,
                  overlayColor: AppTheme.darkTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  trackHeight: 4.0,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                ),
                child: Slider(
                  value: currentPosition,
                  min: 0.0,
                  max: totalDuration,
                  onChanged: onSeek,
                ),
              ),

              // Time indicators
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(currentPosition),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      formatDuration(totalDuration),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Bottom controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side controls
              Row(
                children: [
                  IconButton(
                    onPressed: onPlaylist,
                    icon: CustomIconWidget(
                      iconName: 'playlist_play',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (!isFullscreen) ...[
                    IconButton(
                      onPressed: onShare,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: onDownload,
                      icon: CustomIconWidget(
                        iconName: 'download',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ],
              ),

              // Right side controls
              Row(
                children: [
                  // Volume control
                  SizedBox(
                    width: 80.w,
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: volume > 0.5
                              ? 'volume_up'
                              : volume > 0
                                  ? 'volume_down'
                                  : 'volume_off',
                          color: Colors.white,
                          size: 20,
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor:
                                  Colors.white.withValues(alpha: 0.3),
                              thumbColor: Colors.white,
                              trackHeight: 2.0,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6.0),
                            ),
                            child: Slider(
                              value: volume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: onVolumeChange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isFullscreen) ...[
                    IconButton(
                      onPressed: onQualitySelector,
                      icon: CustomIconWidget(
                        iconName: 'hd',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: onFullscreen,
                      icon: CustomIconWidget(
                        iconName: 'fullscreen',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ] else ...[
                    IconButton(
                      onPressed: onFullscreen,
                      icon: CustomIconWidget(
                        iconName: 'fullscreen_exit',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
