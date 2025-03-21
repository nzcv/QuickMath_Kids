import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'billing_service.dart';

class PurchaseScreen extends ConsumerStatefulWidget {
  const PurchaseScreen({super.key});

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends ConsumerState<PurchaseScreen> {
  bool _isPurchasing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final billingService = ref.watch(billingServiceProvider); // Watch for changes
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Plan',
                          style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Unlock exclusive features with a one-time purchase!',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        ListTile(
                          leading: Icon(Icons.check_circle,
                              color: theme.colorScheme.secondary),
                          title: const Text('Access to Settings Screen'),
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle,
                              color: theme.colorScheme.secondary),
                          title: const Text('Customizable Voice Settings'),
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle,
                              color: theme.colorScheme.secondary),
                          title: const Text('Ad-Free Experience'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Cost: ₹300 (One-Time Payment)',
                          style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No Refunds: This is a non-refundable purchase. Ensure you want to proceed.',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: _isPurchasing || billingService.isPremium
                      ? _isPurchasing
                          ? const CircularProgressIndicator(strokeWidth: 4)
                          : const Text('Already Premium',
                              style: TextStyle(color: Colors.green))
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isPurchasing = true;
                            });
                            final success =
                                await billingService.purchasePremium(context);
                            setState(() {
                              _isPurchasing = false;
                            });
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Purchase successful!')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Purchase for ₹300'),
                        ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}