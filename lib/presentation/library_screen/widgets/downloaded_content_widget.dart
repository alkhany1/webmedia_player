import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DownloadedContentWidget extends StatefulWidget {
  final List<Map<String, dynamic>> content;
  final String searchQuery;
  final VoidCallback onManageStorage;
  final ScrollController scrollController;

  const DownloadedContentWidget({
    super.key,
    required this.content,
    required this.searchQuery,
    required this.onManageStorage,
    required this.scrollController,
  });

  @override
  State<DownloadedContentWidget> createState() =>
      _DownloadedContentWidgetState();
}

class _DownloadedContentWidgetState extends State<DownloadedContentWidget> {
  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'حذف التحميل',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في حذف "${item["title"]}"؟',
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
                // Delete item logic here
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
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
        // Storage info header
        Container(
          margin: EdgeInsets.all(4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.darkTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'storage',
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مساحة التخزين المستخدمة',
                          style: AppTheme.darkTheme.textTheme.titleSmall,
                        ),
                        Text(
                          '3.2 GB من 32 GB',
                          style: AppTheme.darkTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onManageStorage,
                    child: const Text('إدارة'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                value: 0.1,
                backgroundColor:
                    AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
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
                        _deleteItem(item);
                        return false;
                      },
                      child: _buildDownloadedItem(item),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDownloadedItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: item["thumbnail"] ?? "",
              width: 20.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
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
                      iconName: item["type"] == "video"
                          ? 'play_circle'
                          : 'music_note',
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      item["duration"] ?? "",
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '• ${item["quality"]}',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      item["fileSize"] ?? "",
                      style:
                          AppTheme.dataTextStyle(isLight: false, fontSize: 11),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '• ${item["downloadDate"]}',
                      style:
                          AppTheme.dataTextStyle(isLight: false, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Play button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/media-player-screen');
            },
            icon: CustomIconWidget(
              iconName: 'play_arrow',
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
            iconName: 'download',
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'لا توجد تحميلات',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'ابدأ بتحميل المحتوى للمشاهدة دون اتصال',
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
