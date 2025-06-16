import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/recent_urls_widget.dart';
import './widgets/url_input_field_widget.dart';
import './widgets/url_preview_card_widget.dart';

// lib/presentation/url_input_screen/url_input_screen.dart

class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  State<UrlInputScreen> createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends State<UrlInputScreen>
    with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  bool _isValidUrl = false;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _urlPreview;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final KoolToService _koolToService = KoolToService();

  // Recent URLs data
  List<Map<String, dynamic>> _recentUrls = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _urlController.addListener(_onUrlChanged);
    _animationController.forward();

    // Auto-focus and show keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _urlFocusNode.requestFocus();
      _checkClipboard();
      _loadRecentUrls();
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentUrls() async {
    final recentUrls = await _koolToService.getRecentUrls();
    setState(() {
      _recentUrls = recentUrls;
    });
  }

  void _onUrlChanged() {
    final url = _urlController.text.trim();
    setState(() {
      _isValidUrl = _koolToService.isValidKoolToUrl(url);
      _errorMessage = _getUrlErrorMessage(url);
      if (_isValidUrl && url.isNotEmpty) {
        _generateUrlPreview(url);
      } else {
        _urlPreview = null;
      }
    });
  }

  String? _getUrlErrorMessage(String url) {
    if (url.isEmpty) return null;
    if (!_koolToService.isValidKoolToUrl(url)) {
      return 'يرجى إدخال رابط kool.to صحيح';
    }
    return null;
  }

  Future<void> _generateUrlPreview(String url) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final mediaInfo = await _koolToService.extractMediaInfo(url);

      if (mounted) {
        setState(() {
          _urlPreview = mediaInfo;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _urlPreview = {
            "title": "فيديو من kool.to",
            "thumbnail":
                "https://images.unsplash.com/photo-1489599735734-79b4212ccb7c?w=400&h=225&fit=crop",
          };
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null &&
          _koolToService.isValidKoolToUrl(clipboardData!.text!)) {
        _showClipboardSuggestion(clipboardData.text!);
      }
    } catch (e) {
      // Handle clipboard access error silently
    }
  }

  void _showClipboardSuggestion(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم العثور على رابط kool.to في الحافظة'),
        action: SnackBarAction(
          label: 'لصق',
          onPressed: () {
            _urlController.text = url;
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _onStreamNow() async {
    if (!_isValidUrl) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Extract media info if not already done
      Map<String, dynamic>? mediaInfo = _urlPreview;
      mediaInfo ??= await _koolToService.extractMediaInfo(_urlController.text.trim());

      if (mediaInfo != null && mounted) {
        // Navigate to media player with the extracted info
        Navigator.pushNamed(
          context,
          '/media-player-screen',
          arguments: mediaInfo,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء معالجة الرابط، حاول مرة أخرى'),
            backgroundColor: AppTheme.darkTheme.colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء معالجة الرابط، حاول مرة أخرى'),
            backgroundColor: AppTheme.darkTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onAddToQueue() {
    if (!_isValidUrl) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة الرابط إلى قائمة الانتظار'),
        backgroundColor: AppTheme.successColor,
      ),
    );

    _urlController.clear();
  }

  void _onQrScan() {
    // QR scanner functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم فتح ماسح الرمز المربع قريباً'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _onRecentUrlSelected(String url) {
    _urlController.text = url;
    _urlFocusNode.requestFocus();
  }

  void _onRecentUrlRemoved(int index) {
    setState(() {
      _recentUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.darkTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          title: Text(
            'إضافة رابط وسائط',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          centerTitle: true,
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 2.h),

                // URL Input Field
                UrlInputFieldWidget(
                  controller: _urlController,
                  focusNode: _urlFocusNode,
                  isValid: _isValidUrl,
                  errorMessage: _errorMessage,
                  onQrScan: _onQrScan,
                ),

                SizedBox(height: 3.h),

                // URL Preview Card
                if (_urlPreview != null) ...[
                  UrlPreviewCardWidget(
                    previewData: _urlPreview!,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 3.h),
                ],

                // Action Buttons
                ActionButtonsWidget(
                  isValidUrl: _isValidUrl,
                  isLoading: _isLoading,
                  onStreamNow: _onStreamNow,
                  onAddToQueue: _onAddToQueue,
                ),

                SizedBox(height: 4.h),

                // Recent URLs
                if (_recentUrls.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الروابط الأخيرة',
                        style: AppTheme.darkTheme.textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () async {
                          await _koolToService.clearRecentUrls();
                          _loadRecentUrls();
                        },
                        child: Text('مسح الكل'),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  RecentUrlsWidget(
                    recentUrls: _recentUrls,
                    onUrlSelected: _onRecentUrlSelected,
                    onUrlRemoved: _onRecentUrlRemoved,
                  ),
                ],

                SizedBox(height: 10.h), // Extra space for keyboard
              ],
            ),
          ),
        ),
      ),
    );
  }
}
