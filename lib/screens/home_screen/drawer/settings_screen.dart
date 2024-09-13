import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
final volumeProvider = StateProvider<double>((ref) => 1.0);
final pitchProvider = StateProvider<double>((ref) => 1.0);
final speechRateProvider = StateProvider<double>((ref) => 0.5);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = ref.watch(volumeProvider);
    final pitch = ref.watch(pitchProvider);
    final speechRate = ref.watch(speechRateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF009DDC), // Kumon blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Adjust Speech Settings',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF009DDC), // Kumon blue
                  ),
            ),
            const SizedBox(height: 20),
            _buildSlider(
              context,
              label: 'Volume',
              value: volume,
              onChanged: (value) => ref.read(volumeProvider.notifier).state = value,
            ),
            const SizedBox(height: 20),
            _buildSlider(
              context,
              label: 'Pitch',
              value: pitch,
              onChanged: (value) => ref.read(pitchProvider.notifier).state = value,
            ),
            const SizedBox(height: 20),
            _buildSlider(
              context,
              label: 'Speech Rate',
              value: speechRate,
              onChanged: (value) => ref.read(speechRateProvider.notifier).state = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color: const Color(0xFF009DDC), // Kumon blue
              ),
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          onChanged: onChanged,
          activeColor: const Color(0xFF009DDC), // Kumon blue
          inactiveColor: const Color(0xFF009DDC).withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF009DDC), // Kumon blue
                ),
          ),
        ),
      ],
    );
  }
}
