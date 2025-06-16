import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HistoryContentWidget extends StatefulWidget {
  final List<Map<String, dynamic>> content;
  final String searchQuery;
  final VoidCallback onClearHistory;
  final ScrollController scrollController;

  const HistoryContentWidget({
    super.key,
    required this.content,
    required this.searchQuery,
    required this.onClearHistory,
    required this.scrollController,
  });

  @override
  State<HistoryContentWidget> createState() => _HistoryContentWidgetState();
}

class _HistoryContentWidgetState extends State<HistoryContentWidget> {
  void _removeHistoryItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'إزالة من السجل',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في إزالة "${item["title"]}" من السجل؟',
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
                // Remove item logic here
              },
              child: const Text('إزالة'),
            ),
          ],
        );
      },
    );
  }

  String _formatWatchedDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'أمس ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<Map<String, dynamic>> get filteredContent {
    if (widget.searchQuery.isEmpty) return widget.content;
    return widget.content.where((item) {
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
        // Clear history header
        if (filtered.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Text(
                  'السجل',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton(
                  onPressed: widget.onClearHistory,
                  child: Text(
                    'مسح الكل',
                    style: TextStyle(color: AppTheme.errorDark),
                  ),
                ),
              ],
            ),
          ),

        // Content list
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  controller: widget.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Dismissible(
                      key: Key(item["id"].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 4.w),
                        margin: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(
                          color: AppTheme.errorDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: 'delete',
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        _removeHistoryItem(item);
                        return false;
                      },
                      child: _buildHistoryItem(item),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final progress = item["progress"] as double;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Thumbnail with progress overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: item["thumbnail"] ?? "",
                  width: 20.w,
                  height: 15.w,
                  fit: BoxFit.cover,
                ),
              ),

              // Progress overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                  ),
                ),
              ),

              // Completion indicator
              if (progress >= 1.0)
                Positioned(
                  top: 1.w,
                  right: 1.w,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 3.w),

          // Content info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"] ?? "",
                  style: AppTheme.darkTheme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                      '${item["watchedDuration"]} / ${item["duration"]}',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatWatchedDate(item["watchedDate"]),
                      style:
                          AppTheme.dataTextStyle(isLight: false, fontSize: 11),
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

          // Resume/Play button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/media-player-screen');
            },
            icon: CustomIconWidget(
              iconName: progress < 1.0 ? 'play_arrow' : 'replay',
              color: AppTheme.accentColor,
              size: 28,
            ),
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
            iconName: 'history',
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'لا يوجد سجل مشاهدة',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'ابدأ بمشاهدة المحتوى لرؤية سجل المشاهدة هنا',
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search-screen');
            },
            child: const Text('ابدأ المشاهدة'),
          ),
        ],
      ),
    );
  }
}
