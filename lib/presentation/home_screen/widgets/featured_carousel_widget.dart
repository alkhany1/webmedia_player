import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedCarouselWidget extends StatefulWidget {
  final List<Map<String, dynamic>> featuredContent;
  final Function(Map<String, dynamic>) onItemTap;

  const FeaturedCarouselWidget({
    super.key,
    required this.featuredContent,
    required this.onItemTap,
  });

  @override
  State<FeaturedCarouselWidget> createState() => _FeaturedCarouselWidgetState();
}

class _FeaturedCarouselWidgetState extends State<FeaturedCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && widget.featuredContent.isNotEmpty) {
        final nextPage = (_currentPage + 1) % widget.featuredContent.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 30.h,
      child: Column(
        children: [
          // Carousel
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.featuredContent.length,
              itemBuilder: (context, index) {
                final item = widget.featuredContent[index];
                return GestureDetector(
                  onTap: () => widget.onItemTap(item),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CustomImageWidget(
                            imageUrl: item['thumbnail'] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),

                        // Content
                        Positioned(
                          bottom: 4.w,
                          right: 4.w,
                          left: 4.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: AppTheme.darkTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                item['description'] as String,
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),

                        // Play button
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.accentColor.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'play_arrow',
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.featuredContent.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                width: _currentPage == index ? 4.w : 2.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppTheme.accentColor
                      : AppTheme.darkTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
