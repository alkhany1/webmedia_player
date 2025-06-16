import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/recent_search_chip_widget.dart';
import './widgets/search_result_card_widget.dart';
import './widgets/trending_content_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  bool _showSuggestions = false;
  String _selectedFilter = 'الكل';
  List<String> _recentSearches = [];
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _searchSuggestions = [];

  // Mock data for search functionality
  final List<String> _mockRecentSearches = [
    'أفلام عربية',
    'موسيقى كلاسيكية',
    'بودكاست تقني',
    'مسلسلات تركية',
    'أغاني شعبية'
  ];

  final List<Map<String, dynamic>> _mockSearchResults = [
    {
      "id": 1,
      "title": "فيلم الأكشن الجديد - مغامرة مثيرة",
      "creator": "استوديو الأفلام العربية",
      "duration": "2:15:30",
      "quality": "HD",
      "type": "فيديو",
      "thumbnail":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "relevance": 95,
      "views": "1.2M"
    },
    {
      "id": 2,
      "title": "موسيقى هادئة للاسترخاء والتأمل",
      "creator": "فرقة الموسيقى الشرقية",
      "duration": "45:20",
      "quality": "HD",
      "type": "صوت",
      "thumbnail":
          "https://images.pexels.com/photos/164821/pexels-photo-164821.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "relevance": 88,
      "views": "850K"
    },
    {
      "id": 3,
      "title": "بث مباشر - مناقشة التكنولوجيا الحديثة",
      "creator": "قناة التقنية العربية",
      "duration": "مباشر",
      "quality": "4K",
      "type": "بث مباشر",
      "thumbnail":
          "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "relevance": 92,
      "views": "15K مشاهد حالياً"
    },
    {
      "id": 4,
      "title": "مسلسل الدراما التاريخية - الحلقة الأولى",
      "creator": "شبكة الدراما العربية",
      "duration": "52:10",
      "quality": "HD",
      "type": "فيديو",
      "thumbnail":
          "https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "relevance": 85,
      "views": "2.5M"
    },
    {
      "id": 5,
      "title": "بودكاست عن ريادة الأعمال في الوطن العربي",
      "creator": "شبكة البودكاست العربي",
      "duration": "1:25:45",
      "quality": "HD",
      "type": "صوت",
      "thumbnail":
          "https://images.pexels.com/photos/7688336/pexels-photo-7688336.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "relevance": 78,
      "views": "420K"
    }
  ];

  final List<Map<String, dynamic>> _mockTrendingContent = [
    {
      "id": 1,
      "title": "الأفلام الأكثر مشاهدة هذا الأسبوع",
      "thumbnail":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "أفلام"
    },
    {
      "id": 2,
      "title": "موسيقى عربية رائجة",
      "thumbnail":
          "https://images.pexels.com/photos/164821/pexels-photo-164821.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "موسيقى"
    },
    {
      "id": 3,
      "title": "بودكاست تقني شائع",
      "thumbnail":
          "https://images.pexels.com/photos/7688336/pexels-photo-7688336.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "بودكاست"
    }
  ];

  final List<String> _mockSuggestions = [
    'أفلام عربية جديدة',
    'موسيقى كلاسيكية عربية',
    'بودكاست تقني باللغة العربية',
    'مسلسلات تركية مترجمة',
    'أغاني شعبية تراثية',
    'أفلام وثائقية',
    'برامج طبخ عربية'
  ];

  final List<String> _filterOptions = ['الكل', 'فيديو', 'صوت', 'بث مباشر'];

  @override
  void initState() {
    super.initState();
    _recentSearches = List.from(_mockRecentSearches);
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _showSuggestions = query.isNotEmpty;
      if (query.isNotEmpty) {
        _searchSuggestions = _mockSuggestions
            .where((suggestion) => suggestion.contains(query))
            .take(5)
            .toList();
      } else {
        _searchSuggestions.clear();
      }
    });
  }

  void _onScroll() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _showSuggestions = false;
    });

    // Add to recent searches if not already present
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches.removeLast();
      }
    }

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = _mockSearchResults
              .where((result) =>
                  (result['title'] as String).contains(query) ||
                  (result['creator'] as String).contains(query))
              .toList();
        });
      }
    });

    _searchFocusNode.unfocus();
  }

  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      // Filter results based on selected filter
      if (filter == 'الكل') {
        _searchResults = List.from(_mockSearchResults);
      } else {
        _searchResults = _mockSearchResults
            .where((result) => (result['type'] as String) == filter)
            .toList();
      }
    });
  }

  void _startVoiceSearch() {
    HapticFeedback.lightImpact();
    // Voice search implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'البحث الصوتي متاح قريباً',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
      ),
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'فلاتر البحث المتقدمة',
                style: AppTheme.darkTheme.textTheme.titleLarge,
                textDirection: TextDirection.rtl,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'فلاتر البحث المتقدمة قيد التطوير',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshSearch() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _searchResults = List.from(_mockSearchResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Search Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.darkTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.darkTheme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _searchFocusNode.hasFocus
                              ? AppTheme.accentColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        textDirection: TextDirection.rtl,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _performSearch,
                        decoration: InputDecoration(
                          hintText: 'ابحث في محتوى kool.to...',
                          hintStyle:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color:
                                AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                          ),
                          prefixIcon: GestureDetector(
                            onTap: _startVoiceSearch,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: CustomIconWidget(
                                iconName: 'mic',
                                color: AppTheme
                                    .darkTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      _showSuggestions = false;
                                      _searchResults.clear();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: CustomIconWidget(
                                      iconName: 'clear',
                                      color: AppTheme.darkTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: _showAdvancedFilters,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: CustomIconWidget(
                                    iconName: 'tune',
                                    color: AppTheme
                                        .darkTheme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: AppTheme.darkTheme.textTheme.bodyMedium,
                      ),
                    ),

                    // Filter Chips
                    if (!_showSuggestions) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filterOptions.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final filter = _filterOptions[index];
                            return FilterChipWidget(
                              label: filter,
                              isSelected: _selectedFilter == filter,
                              onTap: () => _onFilterSelected(filter),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Search Suggestions Overlay
              if (_showSuggestions && _searchSuggestions.isNotEmpty)
                Container(
                  color: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _searchSuggestions[index];
                      return ListTile(
                        leading: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        title: Text(
                          suggestion,
                          style: AppTheme.darkTheme.textTheme.bodyMedium,
                          textDirection: TextDirection.rtl,
                        ),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
                ),

              // Main Content
              Expanded(
                child: _isSearching
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppTheme.accentColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'جاري البحث...',
                              style: AppTheme.darkTheme.textTheme.bodyMedium,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      )
                    : _searchResults.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: _refreshSearch,
                            color: AppTheme.accentColor,
                            backgroundColor: AppTheme
                                .darkTheme.colorScheme.surfaceContainerHigh,
                            child: ListView.separated(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: _searchResults.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return SearchResultCardWidget(
                                  result: result,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/media-player-screen');
                                  },
                                  onLongPress: () =>
                                      _showResultContextMenu(result),
                                );
                              },
                            ),
                          )
                        : _searchController.text.isNotEmpty
                            ? _buildEmptySearchState()
                            : _buildInitialState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Text(
              'عمليات البحث الأخيرة',
              style: AppTheme.darkTheme.textTheme.titleMedium,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return RecentSearchChipWidget(
                  search: search,
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                  onRemove: () => _removeRecentSearch(search),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Trending Content
          Text(
            'المحتوى الرائج',
            style: AppTheme.darkTheme.textTheme.titleMedium,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockTrendingContent.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final content = _mockTrendingContent[index];
              return TrendingContentWidget(
                content: content,
                onTap: () {
                  _searchController.text = content['title'] as String;
                  _performSearch(content['title'] as String);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'لم يتم العثور على نتائج',
            style: AppTheme.darkTheme.textTheme.titleMedium,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مختلفة أو تحقق من الإملاء',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showResultContextMenu(Map<String, dynamic> result) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'play_arrow',
                color: AppTheme.accentColor,
                size: 24,
              ),
              title: Text(
                'تشغيل الآن',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/media-player-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'queue_play_next',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'تشغيل التالي',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'playlist_add',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'إضافة إلى قائمة الانتظار',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'مشاركة',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'تحميل',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
