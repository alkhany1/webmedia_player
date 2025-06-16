import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SearchResultCardWidget extends StatelessWidget {
  final Map<String, dynamic> result;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SearchResultCardWidget({
    super.key,
    required this.result,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: result['thumbnail'] as String,
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Content Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      result['title'] as String,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Creator
                    Text(
                      result['creator'] as String,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      ),
                      textDirection: TextDirection.rtl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Metadata Row
                    Row(
                      children: [
                        // Duration
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.darkTheme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            result['duration'] as String,
                            style: AppTheme.mediaDataTextStyle(
                              isLight: false,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Quality Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            result['quality'] as String,
                            style: AppTheme.mediaDataTextStyle(
                              isLight: false,
                              fontSize: 10,
                            ).copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Views
                        Text(
                          result['views'] as String,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Relevance Indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(
                    alpha: (result['relevance'] as int) / 100,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
