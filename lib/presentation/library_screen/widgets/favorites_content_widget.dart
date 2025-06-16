import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FavoritesContentWidget extends StatefulWidget {
  final List<Map<String, dynamic>> content;
  final String searchQuery;
  final ScrollController scrollController;

  const FavoritesContentWidget({
    super.key,
    required this.content,
    required this.searchQuery,
    required this.scrollController,
  });

  @override
  State<FavoritesContentWidget> createState() => _FavoritesContentWidgetState();
}

class _FavoritesContentWidgetState extends State<FavoritesContentWidget> {
  bool _isMultiSelectMode = false;
  final Set<int> _selectedItems = {};

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _removeFromFavorites() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'إزالة من المفضلة',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في إزالة ${_selectedItems.length} عنصر من المفضلة؟',
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
                  _selectedItems.clear();
                  _isMultiSelectMode = false;
                });
              },
              child: const Text('إزالة'),
            ),
          ],
        );
      },
    );
  }

  void _shareSelected() {
    // Share functionality
    setState(() {
      _selectedItems.clear();
      _isMultiSelectMode = false;
    });
  }

  void _downloadSelected() {
    // Download functionality
    setState(() {
      _selectedItems.clear();
      _isMultiSelectMode = false;
    });
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
        // Multi-select toolbar
        if (_isMultiSelectMode)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.darkTheme.dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${_selectedItems.length} محدد',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.accentColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _selectedItems.isNotEmpty ? _shareSelected : null,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: _selectedItems.isNotEmpty
                        ? AppTheme.accentColor
                        : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed:
                      _selectedItems.isNotEmpty ? _downloadSelected : null,
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: _selectedItems.isNotEmpty
                        ? AppTheme.accentColor
                        : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed:
                      _selectedItems.isNotEmpty ? _removeFromFavorites : null,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: _selectedItems.isNotEmpty
                        ? AppTheme.errorDark
                        : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: _toggleMultiSelect,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.darkTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

        // Content grid
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  controller: widget.scrollController,
                  padding: EdgeInsets.all(4.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 3.w,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final isSelected = _selectedItems.contains(item["id"]);

                    return GestureDetector(
                      onTap: () {
                        if (_isMultiSelectMode) {
                          _toggleItemSelection(item["id"]);
                        } else {
                          Navigator.pushNamed(context, '/media-player-screen');
                        }
                      },
                      onLongPress: () {
                        if (!_isMultiSelectMode) {
                          _toggleMultiSelect();
                          _toggleItemSelection(item["id"]);
                        }
                      },
                      child: _buildFavoriteItem(item, isSelected),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> item, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppTheme.accentColor, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with overlay
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomImageWidget(
                    imageUrl: item["thumbnail"] ?? "",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Heart icon overlay
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'favorite',
                      color: AppTheme.errorDark,
                      size: 16,
                    ),
                  ),
                ),

                // Selection indicator
                if (_isMultiSelectMode)
                  Positioned(
                    top: 2.w,
                    left: 2.w,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accentColor
                            : Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName:
                            isSelected ? 'check' : 'radio_button_unchecked',
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),

                // Unavailable overlay
                if (!(item["isAvailable"] as bool))
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'cloud_off',
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'غير متاح',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content info
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"] ?? "",
                    style: AppTheme.darkTheme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
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
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    item["source"] ?? "",
                    style: AppTheme.dataTextStyle(isLight: false, fontSize: 10),
                  ),
                ],
              ),
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
            iconName: 'favorite_border',
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'لا توجد مفضلة',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'أضف المحتوى المفضل لديك لسهولة الوصول إليه',
            style: AppTheme.darkTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search-screen');
            },
            child: const Text('اكتشف المحتوى'),
          ),
        ],
      ),
    );
  }
}
