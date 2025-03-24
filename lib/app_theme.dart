import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';

class AppTheme {
  static double _scaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseScale = screenWidth / 360; // Base scaling factor
    // Cap the scaling factor for tablets to avoid excessive shrinking
    return screenWidth > 600 ? baseScale.clamp(0.8, 1.2) : baseScale;
  }

  static ThemeData getTheme(WidgetRef ref, bool isDarkMode, BuildContext context) {
    final billingService = ref.watch(billingServiceProvider);
    final bool isPremium = billingService.isPremium;
    final scale = _scaleFactor(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Core colors
    final Color primaryColor = Colors.blue[600]!; // Always blue for primary elements
    final Color secondaryColor = Colors.blue[300]!; // Lighter blue for secondary elements
    final Color premiumAccentColor = isPremium ? Colors.amber[600]! : Colors.blue[400]!; // Gold for premium, blue for non-premium
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.white;

    // Surface color: Closer to white/black, with a subtle tint of primaryColor
    final Color surfaceColor = isDarkMode
        ? Color.alphaBlend(primaryColor.withOpacity(0.1), Colors.black) // Reduced opacity to 0.1
        : Color.alphaBlend(primaryColor.withOpacity(0.1), Colors.white);

    final Color onPrimaryColor = isDarkMode ? Colors.white : Colors.black;
    final Color onSurfaceColor = isDarkMode ? Colors.white : Colors.black;

    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
        onSecondary: onSurfaceColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        background: backgroundColor,
        onBackground: onSurfaceColor,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor.withOpacity(0.7), // Blue AppBar
        foregroundColor: onPrimaryColor,
        elevation: 0,
        toolbarHeight: 56 * scale,
        titleTextStyle: TextStyle(
          color: onPrimaryColor,
          fontSize: (isTablet ? 18 : 20) * scale,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: premiumAccentColor, // Gold icons for premium users
          size: 22 * scale,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.withOpacity(0.8), // Blue buttons
          foregroundColor: onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16 * scale),
            side: BorderSide(
              color: premiumAccentColor, // Gold border for premium users
              width: 2 * scale,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10 * scale,
            horizontal: 18 * scale,
          ),
          textStyle: TextStyle(
            fontSize: (isTablet ? 16 : 16) * scale,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * scale),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: (isTablet ? 18 : 18) * scale,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        ),
        titleLarge: TextStyle(
          fontSize: (isTablet ? 16 : 16) * scale,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        ),
        bodyLarge: TextStyle(
          fontSize: (isTablet ? 14 : 14) * scale,
          color: onSurfaceColor,
        ),
        titleMedium: TextStyle(
          fontSize: (isTablet ? 14 : 14) * scale,
          color: onSurfaceColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: premiumAccentColor, // Gold icons for premium users
        size: 22 * scale,
      ),
      dividerColor: secondaryColor.withOpacity(0.3),
      scaffoldBackgroundColor: backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: (isTablet ? 14 : 14) * scale,
          color: onSurfaceColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8 * scale)),
          borderSide: BorderSide(
            color: premiumAccentColor, // Gold border for premium users
            width: 2 * scale,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8 * scale)),
          borderSide: BorderSide(
            color: premiumAccentColor, // Gold border for premium users
            width: 2 * scale,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8 * scale)),
          borderSide: BorderSide(
            color: secondaryColor, // Blue when focused
            width: 2 * scale,
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor, // Blue progress indicator
        linearTrackColor: secondaryColor.withOpacity(0.3),
        circularTrackColor: secondaryColor.withOpacity(0.3),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontSize: (isTablet ? 14 : 14) * scale,
          color: onSurfaceColor,
        ),
        backgroundColor: surfaceColor,
      ),
    );
  }
}