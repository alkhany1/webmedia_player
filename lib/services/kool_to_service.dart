// lib/services/kool_to_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KoolToService {
  static final KoolToService _instance = KoolToService._internal();
  final Dio _dio = Dio();

  factory KoolToService() {
    return _instance;
  }

  KoolToService._internal() {
    _dio.options.headers['User-Agent'] =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36';
    _dio.options.followRedirects = true;
  }

  /// Validates if a URL is a valid kool.to URL
  bool isValidKoolToUrl(String url) {
    if (url.isEmpty) return false;
    final koolToPattern =
        RegExp(r'^https?:\/\/(www\.)?kool\.to\/([a-zA-Z0-9-_]+)\/?.*$');
    return koolToPattern.hasMatch(url);
  }

  /// Extracts media information from a kool.to URL
  Future<Map<String, dynamic>?> extractMediaInfo(String url) async {
    try {
      // First, add to recent URLs
      await _addToRecentUrls(url);

      // Then fetch the page to extract metadata
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        // Extract title from the HTML response
        final pageContent = response.data.toString();
        final titleMatch =
            RegExp(r'<title>(.*?)<\/title>').firstMatch(pageContent);
        final title = titleMatch?.group(1) ?? 'محتوى من kool.to';

        // Extract video URL if possible (this is simplified and might need adjustment)
        String? videoUrl = _extractVideoUrl(pageContent);

        // If direct extraction fails, we'll use WebView to play the content
        final useWebView = videoUrl == null;

        // Extract thumbnail if available
        final thumbnailMatch =
            RegExp(r'<meta property="og:image" content="(.*?)"')
                .firstMatch(pageContent);
        final thumbnail = thumbnailMatch?.group(1) ?? '';

        return {
          "title": title,
          "source_url": url,
          "video_url": videoUrl,
          "thumbnail": thumbnail,
          "use_web_view": useWebView,
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error extracting media info: $e');
      return null;
    }
  }

  /// Helper method to extract video URL from HTML content
  String? _extractVideoUrl(String htmlContent) {
    // This is a simplified approach and might need adjustment for kool.to
    final videoSrcMatch =
        RegExp(r'<source\s+src="([^"]+)"').firstMatch(htmlContent);
    if (videoSrcMatch != null) {
      return videoSrcMatch.group(1);
    }

    // Try to find video in JSON-LD data
    final jsonLdMatch = RegExp(
            r'<script type="application\/ld\+json">(.*?)<\/script>',
            dotAll: true)
        .firstMatch(htmlContent);
    if (jsonLdMatch != null) {
      final jsonData = jsonLdMatch.group(1);
      final videoUrlMatch =
          RegExp(r'"contentUrl"\s*:\s*"([^"]+)"').firstMatch(jsonData ?? '');
      if (videoUrlMatch != null) {
        return videoUrlMatch.group(1);
      }
    }

    return null;
  }

  /// Manages the list of recent URLs
  Future<void> _addToRecentUrls(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> recentUrls =
          prefs.getStringList('recent_kool_to_urls') ?? [];

      // Remove if exists and add to beginning (most recent)
      recentUrls.remove(url);
      recentUrls.insert(0, url);

      // Keep only the most recent 10 URLs
      if (recentUrls.length > 10) {
        recentUrls = recentUrls.sublist(0, 10);
      }

      await prefs.setStringList('recent_kool_to_urls', recentUrls);
    } catch (e) {
      debugPrint('Error saving recent URL: $e');
    }
  }

  /// Retrieves the list of recent kool.to URLs
  Future<List<Map<String, dynamic>>> getRecentUrls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> recentUrls =
          prefs.getStringList('recent_kool_to_urls') ?? [];

      List<Map<String, dynamic>> formattedUrls = [];
      for (var url in recentUrls) {
        // Extract a title from the URL
        final uri = Uri.parse(url);
        final pathSegments = uri.pathSegments;
        String title = 'محتوى من kool.to';

        if (pathSegments.isNotEmpty) {
          // Convert slug to title format
          title = pathSegments.last.replaceAll('-', ' ').replaceAll('_', ' ');

          // Capitalize first letter of each word
          title = title
              .split(' ')
              .map((word) => word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '')
              .join(' ');
        }

        formattedUrls.add({
          "url": url,
          "title": title,
          "timestamp": DateTime.now()
              .subtract(Duration(minutes: formattedUrls.length * 30))
              .toString(),
        });
      }

      return formattedUrls;
    } catch (e) {
      debugPrint('Error retrieving recent URLs: $e');
      return [];
    }
  }

  /// Clears the list of recent URLs
  Future<void> clearRecentUrls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recent_kool_to_urls');
    } catch (e) {
      debugPrint('Error clearing recent URLs: $e');
    }
  }
}
