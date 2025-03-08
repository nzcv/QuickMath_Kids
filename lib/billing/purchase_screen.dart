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
    final isDarkMode = theme.brightness == Brightness.dark;
    final billingService = ref.read(billingServiceProvider);

    const goldColor = Color(0xFFFFD700);
    const darkGold = Color(0xFFC0A062);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        backgroundColor: isDarkMode ? darkGold : goldColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor, // Use theme-defined color (black in dark mode)
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium Plan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? goldColor : darkGold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unlock exclusive features with a one-time purchase!',
                        style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      const ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Access to Settings Screen'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Customizable Voice Settings'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Ad-Free Experience'),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Cost: ₹300 (One-Time Payment)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? goldColor : darkGold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No Refunds: This is a non-refundable purchase. Ensure you want to proceed.',
                        style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.red[300] : Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: _isPurchasing
                    ? const CircularProgressIndicator(color: goldColor)
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isPurchasing = true;
                          });
                          final success = await billingService.purchasePremium(context);
                          setState(() {
                            _isPurchasing = false;
                          });
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Purchase successful!')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? darkGold : goldColor,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Purchase for ₹300',
                          style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.black : Colors.white),
                        ),
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
                    style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}