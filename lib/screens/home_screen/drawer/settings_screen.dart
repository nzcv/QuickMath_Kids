import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oral_app/question_logic/tts_translator.dart';

// Providers remain the same
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
    final TextEditingController testTextController = TextEditingController(
      text: "Hello! This is a test of the text-to-speech settings.",
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Settings'),
        backgroundColor: const Color(0xFF009DDC),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF009DDC).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Voice Configuration',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF009DDC),
                              ),
                        ),
                        const SizedBox(height: 24),
                        _buildSlider(
                          context,
                          label: 'Volume',
                          value: volume,
                          icon: Icons.volume_up,
                          onChanged: (value) => ref.read(volumeProvider.notifier).state = value,
                        ),
                        const SizedBox(height: 24),
                        _buildSlider(
                          context,
                          label: 'Pitch',
                          value: pitch,
                          icon: Icons.tune,
                          onChanged: (value) => ref.read(pitchProvider.notifier).state = value,
                        ),
                        const SizedBox(height: 24),
                        _buildSlider(
                          context,
                          label: 'Speech Rate',
                          value: speechRate,
                          icon: Icons.speed,
                          onChanged: (value) => ref.read(speechRateProvider.notifier).state = value,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Voice Settings',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF009DDC),
                              ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: testTextController,
                          maxLines: 3,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter text to test the voice settings...',
                            hintStyle: const TextStyle(
                              color: Colors.white70,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF009DDC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            final ttsService = ref.read(ttsServiceProvider);
                            ttsService.speak(testTextController.text, ref);
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Test Voice',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009DDC),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF009DDC),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF009DDC),
                  ),
            ),
            const Spacer(),
            Container(
              width: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF009DDC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF009DDC),
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            onChanged: onChanged,
            activeColor: const Color(0xFF009DDC),
            inactiveColor: const Color(0xFF009DDC).withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}