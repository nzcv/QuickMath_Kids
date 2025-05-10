import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/home_screen/home_page.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app_theme.dart';

final StateProvider<bool> darkModeProvider = StateProvider<bool>((ref) {
  SharedPreferences.getInstance().then((prefs) {
    ref.read(darkModeProvider.notifier).state = prefs.getBool('isDarkMode') ?? false;
  });
  return false;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final billingService = container.read(billingServiceProvider);
  await billingService.initialize();
  await billingService.restorePurchase();
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return Consumer(
      builder: (context, ref, child) {
        final isDarkMode = ref.watch(darkModeProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(ref, isDarkMode, context),
          home: StartScreen(
            isDarkMode: isDarkMode,
            toggleDarkMode: (value) async {
              ref.read(darkModeProvider.notifier).state = value;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isDarkMode', value);
            },
          ),
        );
      },
    );
  }
}