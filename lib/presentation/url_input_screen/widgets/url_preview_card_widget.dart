import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

// lib/presentation/url_input_screen/widgets/url_preview_card_widget.dart

class UrlPreviewCardWidget extends StatelessWidget {
  final Map<String, dynamic> previewData;
  final bool isLoading;

  const UrlPreviewCardWidget({
    super.key,
    required this.previewData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          if (previewData["thumbnail"] != null &&
              previewData["thumbnail"].toString().isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomImageWidget(
                      imageUrl: previewData["thumbnail"] as String,
                      fit: BoxFit.cover,
                    ),
                    if (isLoading)
                      Container(
                        color: Colors.black.withAlpha(128),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.darkTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(179),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(153),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'play_arrow',
                                  color: AppTheme.darkTheme.colorScheme.primary,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'kool.to',
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Content Info
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  previewData["title"] as String,
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                if (previewData["source_url"] != null) ...[
                  Text(
                    previewData["source_url"] as String,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                  ),
                ],
                SizedBox(height: 8),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: previewData["use_web_view"] == true
                          ? 'web'
                          : 'video_file',
                      color: AppTheme.darkTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      previewData["use_web_view"] == true
                          ? 'عرض صفحة الويب'
                          : 'تشغيل الفيديو مباشرة',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
