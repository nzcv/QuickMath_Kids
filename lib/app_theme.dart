import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';

class AppTheme {
  static double _scaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth / 650; // Base width of 400 for scaling (typical phone width)
  }

  static ThemeData getTheme(WidgetRef ref, bool isDarkMode, BuildContext context) {
    final billingService = ref.watch(billingServiceProvider);
    final bool isPremium = billingService.isPremium;
    final scale = _scaleFactor(context);

    // Core colors
    final Color primaryColor = isPremium ? Colors.amber[600]! : Colors.blue[600]!;
    final Color secondaryColor = isPremium ? Colors.amber[300]! : Colors.blue[300]!;
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.white;

    // Ensure 50% White (Light Mode) / 50% Black (Dark Mode)
    final Color surfaceColor = isDarkMode
        ? Color.alphaBlend(primaryColor.withOpacity(0.3), Colors.black)
        : Color.alphaBlend(primaryColor.withOpacity(0.3), Colors.white);

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
        backgroundColor: primaryColor.withOpacity(0.7),
        foregroundColor: onPrimaryColor,
        titleTextStyle: TextStyle(
          color: onPrimaryColor,
          fontSize: 20 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.withOpacity(0.8),
          foregroundColor: onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20 * scale),
          ),
          padding: EdgeInsets.symmetric(
              vertical: 12 * scale, horizontal: 20 * scale),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16 * scale),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28 * scale,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20 * scale,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16 * scale,
          color: onSurfaceColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16 * scale,
          color: onSurfaceColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: onPrimaryColor,
        size: 28 * scale, // Scaled icon size
      ),
      dividerColor: secondaryColor.withOpacity(0.3),
      scaffoldBackgroundColor: backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 16 * scale,
          color: onSurfaceColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10 * scale)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: secondaryColor.withOpacity(0.3),
        circularTrackColor: secondaryColor.withOpacity(0.3),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontSize: 16 * scale,
          color: onSurfaceColor,
        ),
        backgroundColor: surfaceColor,
      ),
    );
  }
}