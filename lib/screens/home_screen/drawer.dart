import 'package:flutter/material.dart';
import 'package:QuickMath_Kids/screens/settings_screen/settings_screen.dart';
import 'package:QuickMath_Kids/screens/faq/faq_screen.dart';
import 'package:QuickMath_Kids/screens/how_to_use_screen.dart';
import 'package:QuickMath_Kids/wrong_answer_storing/wrong_answer_screen.dart';
import 'package:QuickMath_Kids/quiz_history/quiz_history_screen.dart';
import 'package:QuickMath_Kids/billing/billing_service.dart';
import 'package:QuickMath_Kids/billing/purchase_screen.dart';

class AppDrawer extends StatelessWidget {
  final BillingService billingService;
  final VoidCallback switchToStartScreen;
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  const AppDrawer({
    required this.billingService,
    required this.switchToStartScreen,
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Text(
              'QuickMath Kids',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.help_outline,
            title: 'FAQ',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.help_outline,
            title: 'How to use?',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HowToUseScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            isPremiumRequired: !billingService.isPremium,
            onTap: () {
              Navigator.pop(context);
              if (billingService.isPremium) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PurchaseScreen()),
                );
              }
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.history,
            title: 'Wrong Answers History',
            isPremiumRequired: !billingService.isPremium,
            onTap: () {
              Navigator.pop(context);
              if (billingService.isPremium) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WrongAnswersScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PurchaseScreen()),
                );
              }
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.history_toggle_off,
            title: 'Quiz History',
            isPremiumRequired: !billingService.isPremium,
            onTap: () {
              Navigator.pop(context);
              if (billingService.isPremium) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizHistoryScreen(switchToStartScreen),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PurchaseScreen()),
                );
              }
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.star,
            title: 'Purchase Premium',
            iconColor: Colors.amber,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PurchaseScreen()),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: SwitchListTile(
              title: const Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (bool value) {
                toggleDarkMode(value);
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isPremiumRequired = false,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark 
            ? Colors.grey[800]
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: isPremiumRequired
            ? Border.all(color: theme.colorScheme.error, width: 1.5)
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: theme.colorScheme.primary.withOpacity(0.2),
        highlightColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.white,
                  ),
                ),
              ),
              if (isPremiumRequired)
                Icon(
                  Icons.lock,
                  size: 20,
                  color: theme.colorScheme.error,
                ),
            ],
          ),
        ),
      ),
    );
  }
}