import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/library_screen/library_screen.dart';
import '../presentation/url_input_screen/url_input_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/media_player_screen/media_player_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String mediaPlayerScreen = '/media-player-screen';
  static const String searchScreen = '/search-screen';
  static const String libraryScreen = '/library-screen';
  static const String profileScreen = '/profile-screen';
  static const String urlInputScreen = '/url-input-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    homeScreen: (context) => const HomeScreen(),
    mediaPlayerScreen: (context) => const MediaPlayerScreen(),
    searchScreen: (context) => const SearchScreen(),
    libraryScreen: (context) => const LibraryScreen(),
    profileScreen: (context) => const ProfileScreen(),
    urlInputScreen: (context) => const UrlInputScreen(),
  };
}
