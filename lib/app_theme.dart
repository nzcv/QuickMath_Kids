import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';

class AppTheme {
  static ThemeData getTheme(WidgetRef ref, bool isDarkMode) {
    final billingService = ref.watch(billingServiceProvider);
    final bool isPremium = billingService.isPremium;

    // Define colors
    final Color primaryColor = isPremium ? Colors.amber : Colors.blue;
    final Color secondaryColor = isPremium ? Colors.blue : Colors.amber;
    final Color surfaceColor = isDarkMode
        ? Colors.grey[900]!
        : (isPremium ? Colors.amber[50]! : Colors.blue[50]!);
    final Color backgroundColor = isDarkMode
        ? Colors.grey[850]!
        : (isPremium ? Colors.amber[100]! : Colors.blue[100]!);
    final Color onPrimaryColor = isPremium ? Colors.black : Colors.white;
    final Color onSurfaceColor = isDarkMode ? Colors.white : Colors.black;

    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
        onSecondary: onPrimaryColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        background: backgroundColor,
        onBackground: onSurfaceColor,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        titleTextStyle: TextStyle(
          color: onPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
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
          color: primaryColor,
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
        color: secondaryColor, // Blue icons when premium, gold when not
      ),
      dividerColor: secondaryColor.withOpacity(0.3),
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}