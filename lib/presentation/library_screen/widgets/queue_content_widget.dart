import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QueueContentWidget extends StatefulWidget {
  final List<Map<String, dynamic>> content;
  final String searchQuery;
  final ScrollController scrollController;

  const QueueContentWidget({
    super.key,
    required this.content,
    required this.searchQuery,
    required this.scrollController,
  });

  @override
  State<QueueContentWidget> createState() => _QueueContentWidgetState();
}

class _QueueContentWidgetState extends State<QueueContentWidget> {
  late List<Map<String, dynamic>> _queueItems;

  @override
  void initState() {
    super.initState();
    _queueItems = List.from(widget.content);
  }

  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _queueItems.removeAt(oldIndex);
      _queueItems.insert(newIndex, item);

      // Update positions
      for (int i = 0; i < _queueItems.length; i++) {
        _queueItems[i]["position"] = i + 1;
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _removeFromQueue(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'إزالة من قائمة الانتظار',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في إزالة "${item["title"]}" من قائمة الانتظار؟',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _queueItems.removeWhere(
                      (queueItem) => queueItem["id"] == item["id"]);
                  // Update positions
                  for (int i = 0; i < _queueItems.length; i++) {
                    _queueItems[i]["position"] = i + 1;
                  }
                });
              },
              child: const Text('إزالة'),
            ),
          ],
        );
      },
    );
  }

  void _clearQueue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'مسح قائمة الانتظار',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في مسح جميع عناصر قائمة الانتظار؟',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _queueItems.clear();
                });
              },
              child: const Text('مسح'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> get filteredContent {
    if (widget.searchQuery.isEmpty) return _queueItems;
    return _queueItems.where((item) {
      return (item["title"] as String)
          .toLowerCase()
          .contains(widget.searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredContent;

    return Column(
      children: [
        // Queue header with controls
        if (filtered.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Text(
                  'قائمة الانتظار (${filtered.length})',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/media-player-screen');
                  },
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                  label: const Text('تشغيل الكل'),
                ),
                IconButton(
                  onPressed: _clearQueue,
                  icon: CustomIconWidget(
                    iconName: 'clear_all',
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

        // Reorderable queue list
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState()
              : ReorderableListView.builder(
                  scrollController: widget.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: filtered.length,
                  onReorder: _reorderItems,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildQueueItem(item, index,
                        key: Key(item["id"].toString()));
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQueueItem(Map<String, dynamic> item, int index,
      {required Key key}) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: index == 0
            ? Border.all(
                color: AppTheme.accentColor.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Position indicator
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: index == 0
                  ? AppTheme.accentColor
                  : AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: index == 0
                      ? Colors.white
                      : AppTheme.darkTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: item["thumbnail"] ?? "",
              width: 18.w,
              height: 13.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),

          // Content info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item["title"] ?? "",
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: index == 0 ? AppTheme.accentColor : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (index == 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'التالي',
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      item["duration"] ?? "",
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '• ${item["source"]}',
                      style:
                          AppTheme.dataTextStyle(isLight: false, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/media-player-screen');
                },
                icon: CustomIconWidget(
                  iconName: 'play_arrow',
                  color: AppTheme.accentColor,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () => _removeFromQueue(item),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              // Drag handle
              CustomIconWidget(
                iconName: 'drag_handle',
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'queue_music',
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'قائمة الانتظار فارغة',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'أضف المحتوى إلى قائمة الانتظار للتشغيل المتتالي',
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search-screen');
            },
            child: const Text('استكشف المحتوى'),
          ),
        ],
      ),
    );
  }
}
