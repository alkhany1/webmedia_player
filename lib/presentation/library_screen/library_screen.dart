import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/downloaded_content_widget.dart';
import './widgets/favorites_content_widget.dart';
import './widgets/history_content_widget.dart';
import './widgets/library_search_bar_widget.dart';
import './widgets/queue_content_widget.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for library content
  final List<Map<String, dynamic>> downloadedContent = [
    {
      "id": 1,
      "title": "فيلم الأكشن الجديد",
      "thumbnail":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg",
      "fileSize": "1.2 GB",
      "downloadDate": "2024-01-15",
      "duration": "2:15:30",
      "quality": "1080p",
      "type": "video"
    },
    {
      "id": 2,
      "title": "الموسيقى العربية الكلاسيكية",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/11/29/13/14/attractive-1869761_1280.jpg",
      "fileSize": "45 MB",
      "downloadDate": "2024-01-14",
      "duration": "45:20",
      "quality": "320kbps",
      "type": "audio"
    },
    {
      "id": 3,
      "title": "وثائقي الطبيعة",
      "thumbnail":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4",
      "fileSize": "800 MB",
      "downloadDate": "2024-01-13",
      "duration": "1:30:45",
      "quality": "720p",
      "type": "video"
    }
  ];

  final List<Map<String, dynamic>> favoritesContent = [
    {
      "id": 1,
      "title": "المسلسل الدرامي الشهير",
      "thumbnail":
          "https://images.pexels.com/photos/3945313/pexels-photo-3945313.jpeg",
      "duration": "45:00",
      "addedDate": "2024-01-10",
      "source": "kool.to",
      "isAvailable": true
    },
    {
      "id": 2,
      "title": "برنامج الطبخ العربي",
      "thumbnail":
          "https://images.pixabay.com/photo/2017-05-11/19/44/fresh-fruits-2305192_1280.jpg",
      "duration": "30:15",
      "addedDate": "2024-01-09",
      "source": "kool.to",
      "isAvailable": true
    },
    {
      "id": 3,
      "title": "الكوميديا الليلية",
      "thumbnail":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d",
      "duration": "1:15:30",
      "addedDate": "2024-01-08",
      "source": "kool.to",
      "isAvailable": false
    },
    {
      "id": 4,
      "title": "الأخبار المسائية",
      "thumbnail":
          "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg",
      "duration": "25:45",
      "addedDate": "2024-01-07",
      "source": "kool.to",
      "isAvailable": true
    }
  ];

  final List<Map<String, dynamic>> historyContent = [
    {
      "id": 1,
      "title": "فيلم الخيال العلمي",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/01/09/18/27/camera-1130731_1280.jpg",
      "watchedDate": "2024-01-16 20:30",
      "duration": "2:05:15",
      "watchedDuration": "1:45:20",
      "progress": 0.85,
      "source": "kool.to"
    },
    {
      "id": 2,
      "title": "البودكاست التقني",
      "thumbnail":
          "https://images.unsplash.com/photo-1478737270239-2f02b77fc618",
      "watchedDate": "2024-01-16 14:15",
      "duration": "55:30",
      "watchedDuration": "55:30",
      "progress": 1.0,
      "source": "kool.to"
    },
    {
      "id": 3,
      "title": "المقابلة الحصرية",
      "thumbnail":
          "https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg",
      "watchedDate": "2024-01-15 19:45",
      "duration": "1:20:00",
      "watchedDuration": "35:10",
      "progress": 0.44,
      "source": "kool.to"
    }
  ];

  final List<Map<String, dynamic>> queueContent = [
    {
      "id": 1,
      "title": "الحلقة القادمة من المسلسل",
      "thumbnail":
          "https://images.unsplash.com/photo-1489599735734-79b4212bea40",
      "duration": "42:30",
      "addedDate": "2024-01-16",
      "source": "kool.to",
      "position": 1
    },
    {
      "id": 2,
      "title": "الفيلم الوثائقي الجديد",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/02/13/13/11/oldtimer-1197800_1280.jpg",
      "duration": "1:35:45",
      "addedDate": "2024-01-16",
      "source": "kool.to",
      "position": 2
    },
    {
      "id": 3,
      "title": "الموسيقى الهادئة للاسترخاء",
      "thumbnail":
          "https://images.pexels.com/photos/164821/pexels-photo-164821.jpeg",
      "duration": "2:15:00",
      "addedDate": "2024-01-15",
      "source": "kool.to",
      "position": 3
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && _isSearchVisible) {
      setState(() {
        _isSearchVisible = false;
      });
    } else if (_scrollController.offset <= 50 && !_isSearchVisible) {
      setState(() {
        _isSearchVisible = true;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate refresh data
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'مسح السجل',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في مسح جميع عناصر السجل؟',
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
                // Clear history logic here
              },
              child: const Text('مسح'),
            ),
          ],
        );
      },
    );
  }

  void _manageStorage() {
    Navigator.pushNamed(context, '/storage-management');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with title and search
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.darkTheme.dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'مكتبتي',
                          style: AppTheme.darkTheme.textTheme.headlineMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleSearch,
                        icon: CustomIconWidget(
                          iconName: _isSearchExpanded ? 'close' : 'search',
                          color: AppTheme.darkTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isSearchVisible && _isSearchExpanded ? 6.h : 0,
                    child: _isSearchVisible && _isSearchExpanded
                        ? LibrarySearchBarWidget(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                          )
                        : null,
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.darkTheme.dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppTheme.accentColor,
                unselectedLabelColor:
                    AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                indicatorColor: AppTheme.accentColor,
                indicatorWeight: 3,
                labelStyle: AppTheme.darkTheme.textTheme.titleSmall,
                unselectedLabelStyle: AppTheme.darkTheme.textTheme.titleSmall,
                tabs: const [
                  Tab(text: 'التحميلات'),
                  Tab(text: 'المفضلة'),
                  Tab(text: 'السجل'),
                  Tab(text: 'قائمة الانتظار'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppTheme.accentColor,
                backgroundColor: AppTheme.darkTheme.colorScheme.surface,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    DownloadedContentWidget(
                      content: downloadedContent,
                      searchQuery: _searchQuery,
                      onManageStorage: _manageStorage,
                      scrollController: _scrollController,
                    ),
                    FavoritesContentWidget(
                      content: favoritesContent,
                      searchQuery: _searchQuery,
                      scrollController: _scrollController,
                    ),
                    HistoryContentWidget(
                      content: historyContent,
                      searchQuery: _searchQuery,
                      onClearHistory: _clearHistory,
                      scrollController: _scrollController,
                    ),
                    QueueContentWidget(
                      content: queueContent,
                      searchQuery: _searchQuery,
                      scrollController: _scrollController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
