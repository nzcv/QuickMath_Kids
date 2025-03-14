import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';

class AppTheme {
  static ThemeData getTheme(WidgetRef ref, bool isDarkMode) {
    final billingService = ref.watch(billingServiceProvider);
    final bool isPremium = billingService.isPremium;

    // Core colors
    final Color primaryColor = isPremium ? Colors.amber[600]! : Colors.blue[600]!;
    final Color secondaryColor = isPremium ? Colors.amber[300]! : Colors.blue[300]!;
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    
    // Ensure 50% White (Light Mode) / 50% Black (Dark Mode)
    final Color surfaceColor = isDarkMode 
        ? Color.alphaBlend(primaryColor.withOpacity(0.3), Colors.black)  // 30% primary, 70% black
        : Color.alphaBlend(primaryColor.withOpacity(0.3), Colors.white); // 30% primary, 70% white

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
        backgroundColor: primaryColor.withOpacity(0.7), // Less strong primary
        foregroundColor: onPrimaryColor,
        titleTextStyle: TextStyle(
          color: onPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.withOpacity(0.8), // More subtle
          foregroundColor: onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: onSurfaceColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          color: onSurfaceColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: onSurfaceColor,
      ),
      dividerColor: secondaryColor.withOpacity(0.3),
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}

