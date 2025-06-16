import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/app_export.dart';

// lib/widgets/custom_webview_widget.dart

class CustomWebViewWidget extends StatefulWidget {
  final String url;
  final double height;
  final String title;
  final bool showControls;

  const CustomWebViewWidget({
    super.key,
    required this.url,
    this.height = 30,
    this.title = '',
    this.showControls = false,
  });

  @override
  State<CustomWebViewWidget> createState() => _CustomWebViewWidgetState();
}

class _CustomWebViewWidgetState extends State<CustomWebViewWidget> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Handle error
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                if (widget.showControls)
                  Row(
                    children: [
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.darkTheme.colorScheme.onSurface,
                          size: 20,
                        ),
                        onPressed: () {
                          controller.reload();
                        },
                      ),
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: 'open_in_new',
                          color: AppTheme.darkTheme.colorScheme.onSurface,
                          size: 20,
                        ),
                        onPressed: () {
                          // Open in external browser or full screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text(widget.title),
                                  backgroundColor:
                                      AppTheme.darkTheme.colorScheme.surface,
                                ),
                                body: WebViewWidget(controller: controller),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
        ],
        Container(
          height: widget.height.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.1),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              WebViewWidget(controller: controller),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.accentColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
