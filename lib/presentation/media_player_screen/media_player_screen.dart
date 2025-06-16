import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/media_controls_widget.dart';
import './widgets/media_info_widget.dart';
import './widgets/video_player_widget.dart';

// lib/presentation/media_player_screen/media_player_screen.dart

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({super.key});

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen>
    with TickerProviderStateMixin {
  bool _isFullscreen = false;
  bool _showControls = true;
  bool _isPlaying = false;
  final bool _isBuffering = false;
  bool _showPlaylist = false;
  bool _showQualitySelector = false;
  double _currentPosition = 0.0;
  final double _totalDuration = 300.0; // 5 minutes mock duration
  double _volume = 0.8;
  final String _currentQuality = '720p';
  late AnimationController _controlsAnimationController;
  late AnimationController _playlistAnimationController;

  // Media data
  Map<String, dynamic>? _mediaData;
  bool _useWebView = false;

  @override
  void initState() {
    super.initState();
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _playlistAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controlsAnimationController.forward();
    _startAutoHideTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parseArguments();
  }

  void _parseArguments() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      setState(() {
        _mediaData = args;
        _useWebView = args["use_web_view"] == true;
      });
    } else {
      // Use default mock data if no arguments passed
      setState(() {
        _mediaData = {
          "title": "مقطع فيديو تجريبي - عرض تقديمي للتطبيق",
          "description":
              "هذا مقطع فيديو تجريبي يوضح إمكانيات مشغل الوسائط المتقدم مع دعم كامل للغة العربية والتحكم في الجودة",
          "thumbnail":
              "https://images.pexels.com/photos/3945313/pexels-photo-3945313.jpeg",
          "video_url":
              "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
          "source_url": "https://kool.to/sample",
          "use_web_view": false,
        };
        _useWebView = false;
      });
    }
  }

  @override
  void dispose() {
    _controlsAnimationController.dispose();
    _playlistAnimationController.dispose();
    super.dispose();
  }

  void _startAutoHideTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isFullscreen && _showControls) {
        _hideControls();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _controlsAnimationController.forward();
      if (_isFullscreen) {
        _startAutoHideTimer();
      }
    } else {
      _controlsAnimationController.reverse();
    }
  }

  void _hideControls() {
    if (mounted) {
      setState(() {
        _showControls = false;
      });
      _controlsAnimationController.reverse();
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _skipBackward() {
    setState(() {
      _currentPosition = (_currentPosition - 15).clamp(0.0, _totalDuration);
    });
  }

  void _skipForward() {
    setState(() {
      _currentPosition = (_currentPosition + 15).clamp(0.0, _totalDuration);
    });
  }

  void _onSeek(double value) {
    setState(() {
      _currentPosition = value;
    });
  }

  void _togglePlaylist() {
    setState(() {
      _showPlaylist = !_showPlaylist;
    });
    if (_showPlaylist) {
      _playlistAnimationController.forward();
    } else {
      _playlistAnimationController.reverse();
    }
  }

  void _shareMedia() {
    if (_mediaData != null && _mediaData!["source_url"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم نسخ رابط المقطع'),
          backgroundColor: AppTheme.darkTheme.colorScheme.secondary,
        ),
      );
    }
  }

  void _downloadMedia() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('بدء تحميل المقطع...'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  String _formatDuration(double seconds) {
    final int minutes = (seconds / 60).floor();
    final int remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_mediaData == null) {
      return Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('مشغل الوسائط'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isFullscreen ? _buildFullscreenView() : _buildPortraitView(),
      ),
    );
  }

  Widget _buildPortraitView() {
    return Column(
      children: [
        // Media Player Section
        SizedBox(
          width: double.infinity,
          height: 220.h,
          child: _useWebView
              ? CustomWebViewWidget(
                  url: _mediaData!["source_url"] as String,
                  height: 220.h,
                  showControls: true,
                )
              : VideoPlayerWidget(
                  videoUrl: _mediaData!["video_url"] as String? ?? "",
                  thumbnail: _mediaData!["thumbnail"] as String? ?? "",
                  isPlaying: _isPlaying,
                  isBuffering: _isBuffering,
                  showControls: _showControls,
                  onTap: _toggleControls,
                  onDoubleTapLeft: _skipBackward,
                  onDoubleTapRight: _skipForward,
                ),
        ),

        // Controls Overlay - Only show for video player, not WebView
        if (!_useWebView && _showControls)
          AnimatedBuilder(
            animation: _controlsAnimationController,
            builder: (context, child) {
              return Opacity(
                opacity: _controlsAnimationController.value,
                child: MediaControlsWidget(
                  isPlaying: _isPlaying,
                  currentPosition: _currentPosition,
                  totalDuration: _totalDuration,
                  volume: _volume,
                  onPlayPause: _togglePlayPause,
                  onSkipBackward: _skipBackward,
                  onSkipForward: _skipForward,
                  onSeek: _onSeek,
                  onVolumeChange: (value) => setState(() => _volume = value),
                  onFullscreen: _toggleFullscreen,
                  onPlaylist: _togglePlaylist,
                  onShare: _shareMedia,
                  onDownload: _downloadMedia,
                  onQualitySelector: () =>
                      setState(() => _showQualitySelector = true),
                  formatDuration: _formatDuration,
                ),
              );
            },
          ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaInfoWidget(
                  title: _mediaData!["title"] as String,
                  description: _mediaData!["description"] as String? ?? "",
                  views: _mediaData!["views"] as String? ?? "0",
                  uploadDate:
                      _mediaData!["uploadDate"] as String? ?? "غير معروف",
                  channel: _mediaData!["channel"] as String? ?? "kool.to",
                ),
                SizedBox(height: 24.h),

                // Source Link
                if (_mediaData!["source_url"] != null) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'link',
                          color: AppTheme.darkTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _mediaData!["source_url"] as String,
                            style: AppTheme.darkTheme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: _mediaData!["source_url"] as String));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تم نسخ الرابط'),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          },
                          icon: CustomIconWidget(
                            iconName: 'content_copy',
                            color:
                                AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Related Videos Section - This would be populated with real data from kool.to
                Text(
                  'مقاطع ذات صلة',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'ستظهر هنا مقاطع ذات صلة من kool.to',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullscreenView() {
    if (_useWebView) {
      return Stack(
        children: [
          // WebView in fullscreen
          Positioned.fill(
            child: CustomWebViewWidget(
              url: _mediaData!["source_url"] as String,
              showControls: false,
            ),
          ),

          // Back Button
          Positioned(
            top: 16.h,
            left: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: _toggleFullscreen,
                icon: CustomIconWidget(
                  iconName: 'fullscreen_exit',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        // Fullscreen Video Player
        Positioned.fill(
          child: VideoPlayerWidget(
            videoUrl: _mediaData!["video_url"] as String? ?? "",
            thumbnail: _mediaData!["thumbnail"] as String? ?? "",
            isPlaying: _isPlaying,
            isBuffering: _isBuffering,
            showControls: false,
            onTap: _toggleControls,
            onDoubleTapLeft: _skipBackward,
            onDoubleTapRight: _skipForward,
          ),
        ),

        // Fullscreen Controls Overlay
        if (_showControls)
          AnimatedBuilder(
            animation: _controlsAnimationController,
            builder: (context, child) {
              return Opacity(
                opacity: _controlsAnimationController.value,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: MediaControlsWidget(
                    isPlaying: _isPlaying,
                    currentPosition: _currentPosition,
                    totalDuration: _totalDuration,
                    volume: _volume,
                    onPlayPause: _togglePlayPause,
                    onSkipBackward: _skipBackward,
                    onSkipForward: _skipForward,
                    onSeek: _onSeek,
                    onVolumeChange: (value) => setState(() => _volume = value),
                    onFullscreen: _toggleFullscreen,
                    onPlaylist: _togglePlaylist,
                    onShare: _shareMedia,
                    onDownload: _downloadMedia,
                    onQualitySelector: () =>
                        setState(() => _showQualitySelector = true),
                    formatDuration: _formatDuration,
                    isFullscreen: true,
                  ),
                ),
              );
            },
          ),

        // Back Button
        if (_showControls)
          Positioned(
            top: 16.h,
            left: 16.w,
            child: AnimatedBuilder(
              animation: _controlsAnimationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _controlsAnimationController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
