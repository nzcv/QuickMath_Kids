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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(Icons.help_outline,
                  color: theme.colorScheme.primary),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(Icons.help_outline,
                  color: theme.colorScheme.primary),
              title: const Text('How to use?'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowToUseScreen()),
                );
              },
            ),
          ),
          Container(
            margin: billingService.isPremium
                ? const EdgeInsets.symmetric(vertical: 4)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: !billingService.isPremium
                ? BoxDecoration(
                    border:
                        Border.all(color: theme.colorScheme.error, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  )
                : null,
            child: ListTile(
              leading: Icon(Icons.settings,
                  color: theme.colorScheme.primary),
              title: const Text('Settings'),
              trailing: !billingService.isPremium
                  ? Icon(Icons.lock, size: 20, color: theme.colorScheme.error)
                  : null,
              onTap: () {
                Navigator.pop(context);
                if (billingService.isPremium) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseScreen()),
                  );
                }
              },
            ),
          ),
          Container(
            margin: billingService.isPremium
                ? const EdgeInsets.symmetric(vertical: 4)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: !billingService.isPremium
                ? BoxDecoration(
                    border:
                        Border.all(color: theme.colorScheme.error, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  )
                : null,
            child: ListTile(
              leading:
                  Icon(Icons.history, color: theme.colorScheme.primary),
              title: const Text('Wrong Answers History'),
              trailing: !billingService.isPremium
                  ? Icon(Icons.lock, size: 20, color: theme.colorScheme.error)
                  : null,
              onTap: () {
                Navigator.pop(context);
                if (billingService.isPremium) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WrongAnswersScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseScreen()),
                  );
                }
              },
            ),
          ),
          Container(
            margin: billingService.isPremium
                ? const EdgeInsets.symmetric(vertical: 4)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: !billingService.isPremium
                ? BoxDecoration(
                    border:
                        Border.all(color: theme.colorScheme.error, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  )
                : null,
            child: ListTile(
              leading: Icon(Icons.history_toggle_off,
                  color: theme.colorScheme.primary),
              title: const Text('Quiz History'),
              trailing: !billingService.isPremium
                  ? Icon(Icons.lock, size: 20, color: theme.colorScheme.error)
                  : null,
              onTap: () {
                Navigator.pop(context);
                if (billingService.isPremium) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizHistoryScreen(switchToStartScreen),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseScreen()),
                  );
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(Icons.star,
                  color: theme.iconTheme.color),
              title: const Text('Purchase Premium'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PurchaseScreen()),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: SwitchListTile(
              title: const Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (bool value) {
                toggleDarkMode(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}