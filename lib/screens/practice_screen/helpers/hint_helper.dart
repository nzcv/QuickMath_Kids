// hint_manager.dart
import 'dart:math';

class HintManager {
  final List<String> hintMessages = [
    "Tap the speaker to hear the question! 🔊",
    "Click the blue icon to hear me read the question! 📢",
    "Need help? Press the speaker icon! 🎯",
    "Tap to hear the question read aloud! 🎧",
    "Listen to the question by tapping the speaker! 👂",
    "Press the blue speaker for audio help! 🔉",
    "Tap to hear - I'm here to help! 🎤",
    "Click the speaker and let me guide you! 🗣️",
    "Stuck? Just tap the speaker! 🎙️",
    "Want to listen? Hit the blue speaker icon! 🎶",
    "Need assistance? The speaker's got you covered! 📖",
    "Press the speaker to hear the question explained! 🔔",
    "Tap the speaker icon and I'll read it for you! 📜",
    "Tap the sound icon for a hint! 🕪",
    "Hear it out! Tap the blue speaker icon. 🎵",
    "Press the speaker button for quick help! 🚀",
    "Audio guidance is just a tap away! 🎼",
    "Let me read it for you! Hit the speaker! 📣",
    "Tap the speaker if you're unsure! 💡",
    "Need clarity? Tap the audio icon! 🧠",
    "The speaker icon is your helper! Tap it! 🎧",
    "Don't miss it—click the speaker for details! 📖",
    "For help, tap the sound icon! 🛠️",
    "Tap the speaker to follow along! 🌟",
    "Quick help is a tap away—try the speaker! 🖤",
    "Get a little help—tap the speaker! 😊",
    "I'm here to help—just tap the speaker! 💬",
  ];

  String getRandomHintMessage() {
    final random = Random();
    return hintMessages[random.nextInt(hintMessages.length)];
  }
}
