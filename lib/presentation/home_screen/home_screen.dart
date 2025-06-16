import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/featured_carousel_widget.dart';
import './widgets/media_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _selectedCategory = 'الكل';

  // Mock data for media content
  final List<Map<String, dynamic>> _mediaContent = [
    {
      "id": 1,
      "title": "فيلم الأكشن الجديد - مغامرة مثيرة",
      "thumbnail":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "duration": "2:15:30",
      "quality": "HD",
      "type": "video",
      "url": "https://kool.to/sample-video-1",
      "views": "1.2M",
      "uploadDate": "منذ يومين"
    },
    {
      "id": 2,
      "title": "موسيقى عربية كلاسيكية - أجمل الألحان",
      "thumbnail":
          "https://images.pexels.com/photos/164821/pexels-photo-164821.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "duration": "45:20",
      "quality": "HQ",
      "type": "audio",
      "url": "https://kool.to/sample-audio-1",
      "views": "850K",
      "uploadDate": "منذ 3 أيام"
    },
    {
      "id": 3,
      "title": "بث مباشر - مباراة كرة القدم",
      "thumbnail":
          "https://images.pexels.com/photos/274422/pexels-photo-274422.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "duration": "مباشر",
      "quality": "4K",
      "type": "live",
      "url": "https://kool.to/live-stream-1",
      "views": "15K مشاهد",
      "uploadDate": "الآن"
    },
    {
      "id": 4,
      "title": "وثائقي عن الطبيعة - عجائب العالم",
      "thumbnail":
          "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "duration": "1:30:45",
      "quality": "HD",
      "type": "video",
      "url": "https://kool.to/documentary-1",
      "views": "2.5M",
      "uploadDate": "منذ أسبوع"
    },
    {
      "id": 5,
      "title": "بودكاست تقني - أحدث التطورات",
      "thumbnail":
          "https://images.pexels.com/photos/7130560/pexels-photo-7130560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "duration": "1:05:15",
      "quality": "HQ",
      "type": "audio",
      "url": "https://kool.to/podcast-1",
      "views": "450K",
      "uploadDate": "منذ 5 أيام"
    },
  ];

  final List<Map<String, dynamic>> _featuredContent = [
    {
      "id": 1,
      "title": "المحتوى المميز - أفضل الأفلام",
      "thumbnail":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "مجموعة من أفضل الأفلام العربية والعالمية",
      "url": "https://kool.to/featured-1"
    },
    {
      "id": 2,
      "title": "الموسيقى الشعبية - تراث أصيل",
      "thumbnail":
          "https://images.pexels.com/photos/164821/pexels-photo-164821.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "أجمل الأغاني التراثية والشعبية",
      "url": "https://kool.to/featured-2"
    },
    {
      "id": 3,
      "title": "البرامج الوثائقية - معرفة وثقافة",
      "thumbnail":
          "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description": "برامج وثائقية متنوعة ومفيدة",
      "url": "https://kool.to/featured-3"
    },
  ];

  final List<String> _categories = [
    'الكل',
    'فيديو',
    'صوت',
    'مباشر',
    'حديث',
    'شائع',
    'أفلام',
    'موسيقى',
    'رياضة',
    'أخبار'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreContent();
    }
  }

  Future<void> _loadMoreContent() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshContent() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onMediaTap(Map<String, dynamic> media) {
    Navigator.pushNamed(context, '/media-player-screen');
  }

  void _onMediaLongPress(Map<String, dynamic> media) {
    _showQuickActions(media);
  }

  void _showQuickActions(Map<String, dynamic> media) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'queue_music',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'إضافة إلى القائمة',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                Navigator.pop(context);
              },
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
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'تحميل للمشاهدة بدون إنترنت',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/search-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/library-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-screen');
        break;
    }
  }

  void _onUrlInputTap() {
    Navigator.pushNamed(context, '/url-input-screen');
  }

  List<Map<String, dynamic>> get _filteredContent {
    if (_selectedCategory == 'الكل') {
      return _mediaContent;
    }

    String filterType = '';
    switch (_selectedCategory) {
      case 'فيديو':
        filterType = 'video';
        break;
      case 'صوت':
        filterType = 'audio';
        break;
      case 'مباشر':
        filterType = 'live';
        break;
      default:
        return _mediaContent;
    }

    return _mediaContent
        .where((item) => (item['type'] as String) == filterType)
        .toList();
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
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Network status indicator
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'wifi',
                            color: AppTheme.successColor,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'متصل',
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // App logo
                    Row(
                      children: [
                        Text(
                          'WebMedia',
                          style:
                              AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'play_circle_filled',
                          color: AppTheme.accentColor,
                          size: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshContent,
                  color: AppTheme.accentColor,
                  backgroundColor: AppTheme.darkTheme.colorScheme.surface,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Featured carousel
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          child: FeaturedCarouselWidget(
                            featuredContent: _featuredContent,
                            onItemTap: _onMediaTap,
                          ),
                        ),
                      ),

                      // Kool.to WebView
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 4.w),
                          child: const CustomWebViewWidget(
                            url: 'https://kool.to',
                            height: 30,
                            title: 'موقع kool.to',
                            showControls: true,
                          ),
                        ),
                      ),

                      // Category chips
                      SliverToBoxAdapter(
                        child: Container(
                          height: 6.h,
                          margin: EdgeInsets.only(bottom: 2.h),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return CategoryChipWidget(
                                category: _categories[index],
                                isSelected:
                                    _selectedCategory == _categories[index],
                                onTap: () =>
                                    _onCategorySelected(_categories[index]),
                              );
                            },
                          ),
                        ),
                      ),

                      // Media content grid
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= _filteredContent.length) {
                                return _isLoading
                                    ? Container(
                                        padding: EdgeInsets.all(4.w),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppTheme.accentColor,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }

                              return Container(
                                margin: EdgeInsets.only(bottom: 4.w),
                                child: MediaCardWidget(
                                  media: _filteredContent[index],
                                  onTap: () =>
                                      _onMediaTap(_filteredContent[index]),
                                  onLongPress: () => _onMediaLongPress(
                                      _filteredContent[index]),
                                ),
                              );
                            },
                            childCount:
                                _filteredContent.length + (_isLoading ? 1 : 0),
                          ),
                        ),
                      ),

                      // Empty state
                      if (_filteredContent.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'video_library',
                                  color: AppTheme
                                      .darkTheme.colorScheme.onSurfaceVariant,
                                  size: 64,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'لا يوجد محتوى متاح',
                                  style:
                                      AppTheme.darkTheme.textTheme.titleMedium,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'تصفح kool.to للعثور على محتوى رائع',
                                  style: AppTheme.darkTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .darkTheme.colorScheme.onSurfaceVariant,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Floating action button for URL input
        floatingActionButton: FloatingActionButton(
          onPressed: _onUrlInputTap,
          backgroundColor: AppTheme.accentColor,
          child: CustomIconWidget(
            iconName: 'link',
            color: Colors.white,
            size: 24,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        // Bottom navigation bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkTheme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentTabIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppTheme.accentColor,
            unselectedItemColor:
                AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            items: [
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'home',
                  color: _currentTabIndex == 0
                      ? AppTheme.accentColor
                      : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'search',
                  color: _currentTabIndex == 1
                      ? AppTheme.accentColor
                      : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                label: 'البحث',
              ),
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'video_library',
                  color: _currentTabIndex == 2
                      ? AppTheme.accentColor
                      : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                label: 'المكتبة',
              ),
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'person',
                  color: _currentTabIndex == 3
                      ? AppTheme.accentColor
                      : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                label: 'الملف الشخصي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
