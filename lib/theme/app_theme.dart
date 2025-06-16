import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the mobile media streaming application.
/// Implements Adaptive Media Dark theme optimized for extended viewing sessions.
class AppTheme {
  AppTheme._();

  // Adaptive Media Dark Color Palette - Optimized for OLED displays and extended viewing
  static const Color primaryDark =
      Color(0xFF1A1A1A); // Deep charcoal background
  static const Color secondaryDark =
      Color(0xFF2D2D2D); // Elevated surface color
  static const Color accentColor =
      Color(0xFFFF6B35); // Vibrant orange for interactions
  static const Color surfaceDark = Color(0xFF121212); // True dark surface
  static const Color onSurfaceDark = Color(0xFFE8E8E8); // High-contrast text
  static const Color surfaceVariantDark =
      Color(0xFF404040); // Medium contrast surface
  static const Color onSurfaceVariantDark = Color(0xFFB8B8B8); // Muted text
  static const Color errorDark = Color(0xFFFF5252); // Clear error indication
  static const Color successColor = Color(0xFF4CAF50); // Positive feedback
  static const Color warningColor =
      Color(0xFFFFC107); // Attention-grabbing warnings

  // Light theme colors (minimal usage for system compatibility)
  static const Color primaryLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1A1A1A);

  // Shadow and divider colors
  static const Color shadowDark = Color(0x1A000000);
  static const Color dividerDark = Color(0x1FFFFFFF);
  static const Color shadowLight = Color(0x1F000000);
  static const Color dividerLight = Color(0x1F000000);

  /// Dark theme - Primary theme for media streaming application
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accentColor,
      onPrimary: Colors.white,
      primaryContainer: accentColor.withValues(alpha: 0.2),
      onPrimaryContainer: accentColor,
      secondary: secondaryDark,
      onSecondary: onSurfaceDark,
      secondaryContainer: surfaceVariantDark,
      onSecondaryContainer: onSurfaceVariantDark,
      tertiary: successColor,
      onTertiary: Colors.white,
      tertiaryContainer: successColor.withValues(alpha: 0.2),
      onTertiaryContainer: successColor,
      error: errorDark,
      onError: Colors.white,
      errorContainer: errorDark.withValues(alpha: 0.2),
      onErrorContainer: errorDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      surfaceContainerHighest: secondaryDark,
      surfaceContainerHigh: surfaceVariantDark,
      surfaceContainer: primaryDark,
      surfaceContainerLow: surfaceDark,
      surfaceContainerLowest: Colors.black,
      onSurfaceVariant: onSurfaceVariantDark,
      outline: dividerDark,
      outlineVariant: surfaceVariantDark,
      shadow: shadowDark,
      scrim: Colors.black54,
      inverseSurface: surfaceLight,
      onInverseSurface: onSurfaceLight,
      inversePrimary: accentColor,
      surfaceTint: accentColor,
    ),
    scaffoldBackgroundColor: primaryDark,
    cardColor: secondaryDark,
    dividerColor: dividerDark,

    // AppBar theme for media controls
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: onSurfaceDark,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: onSurfaceDark,
      ),
    ),

    // Card theme for content containers
    cardTheme: CardTheme(
      color: secondaryDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation for media controls
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryDark,
      selectedItemColor: accentColor,
      unselectedItemColor: onSurfaceVariantDark,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button for contextual controls
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accentColor,
        disabledForegroundColor: onSurfaceVariantDark,
        disabledBackgroundColor: surfaceVariantDark,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        disabledForegroundColor: onSurfaceVariantDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: accentColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        disabledForegroundColor: onSurfaceVariantDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Typography theme using Inter font family
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration for search and forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceVariantDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorDark, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorDark, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: onSurfaceVariantDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: onSurfaceVariantDark.withValues(alpha: 0.6),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: onSurfaceVariantDark,
      suffixIconColor: onSurfaceVariantDark,
    ),

    // Switch theme for settings
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor;
        }
        return onSurfaceVariantDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor.withValues(alpha: 0.5);
        }
        return surfaceVariantDark;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: onSurfaceVariantDark, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor;
        }
        return onSurfaceVariantDark;
      }),
    ),

    // Progress indicator theme for buffering
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentColor,
      linearTrackColor: surfaceVariantDark,
      circularTrackColor: surfaceVariantDark,
    ),

    // Slider theme for seek controls
    sliderTheme: SliderThemeData(
      activeTrackColor: accentColor,
      inactiveTrackColor: surfaceVariantDark,
      thumbColor: accentColor,
      overlayColor: accentColor.withValues(alpha: 0.2),
      valueIndicatorColor: accentColor,
      valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tab bar theme for navigation
    tabBarTheme: TabBarTheme(
      labelColor: accentColor,
      unselectedLabelColor: onSurfaceVariantDark,
      indicatorColor: accentColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: secondaryDark,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: onSurfaceDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Snackbar theme for notifications
    snackBarTheme: SnackBarThemeData(
      backgroundColor: secondaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: onSurfaceDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
    ),

    // Bottom sheet theme for media selection
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: secondaryDark,
      modalBackgroundColor: secondaryDark,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),

    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: secondaryDark,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: onSurfaceDark,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: onSurfaceDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: accentColor.withValues(alpha: 0.1),
      iconColor: onSurfaceVariantDark,
      textColor: onSurfaceDark,
      selectedColor: accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );

  /// Light theme - Minimal implementation for system compatibility
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: accentColor,
      onPrimary: Colors.white,
      primaryContainer: accentColor.withValues(alpha: 0.1),
      onPrimaryContainer: accentColor,
      secondary: secondaryLight,
      onSecondary: onSurfaceLight,
      secondaryContainer: Colors.grey[100]!,
      onSecondaryContainer: onSurfaceLight,
      tertiary: successColor,
      onTertiary: Colors.white,
      tertiaryContainer: successColor.withValues(alpha: 0.1),
      onTertiaryContainer: successColor,
      error: errorDark,
      onError: Colors.white,
      errorContainer: errorDark.withValues(alpha: 0.1),
      onErrorContainer: errorDark,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      surfaceContainerHighest: Colors.grey[200]!,
      surfaceContainerHigh: Colors.grey[100]!,
      surfaceContainer: Colors.grey[50]!,
      surfaceContainerLow: surfaceLight,
      surfaceContainerLowest: Colors.white,
      onSurfaceVariant: Colors.grey[600]!,
      outline: dividerLight,
      outlineVariant: Colors.grey[300]!,
      shadow: shadowLight,
      scrim: Colors.black54,
      inverseSurface: primaryDark,
      onInverseSurface: onSurfaceDark,
      inversePrimary: accentColor,
      surfaceTint: accentColor,
    ),
    scaffoldBackgroundColor: surfaceLight,
    textTheme: _buildTextTheme(isLight: true),
  );

  /// Helper method to build text theme with Inter and JetBrains Mono fonts
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textColor = isLight ? onSurfaceLight : onSurfaceDark;
    final Color textMediumColor =
        isLight ? onSurfaceLight.withValues(alpha: 0.7) : onSurfaceVariantDark;
    final Color textLowColor = isLight
        ? onSurfaceLight.withValues(alpha: 0.5)
        : onSurfaceVariantDark.withValues(alpha: 0.7);

    return TextTheme(
      // Display styles for hero content
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      // Headline styles for content titles
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),

      // Title styles for sections and cards
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),

      // Body text for descriptions and content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumColor,
        letterSpacing: 0.4,
      ),

      // Label styles for buttons and captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textLowColor,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Custom text styles for data display (timestamps, file sizes, etc.)
  static TextStyle dataTextStyle(
      {required bool isLight, double fontSize = 12}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: isLight
          ? onSurfaceLight.withValues(alpha: 0.7)
          : onSurfaceVariantDark,
      letterSpacing: 0.5,
    );
  }

  /// Custom text style for media data (duration, quality, etc.)
  static TextStyle mediaDataTextStyle(
      {required bool isLight, double fontSize = 14}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: isLight ? onSurfaceLight : onSurfaceDark,
      letterSpacing: 0.25,
    );
  }
}
