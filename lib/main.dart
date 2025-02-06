import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:QuickMath_Kids/screens/home_screen/home_page.dart';
import 'package:QuickMath_Kids/screens/practice_screen/practice_screen.dart';
import 'package:QuickMath_Kids/screens/result_screen/result_screen.dart';
import 'package:QuickMath_Kids/question_logic/tts_translator.dart';
import 'package:QuickMath_Kids/question_logic/question_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
}

/// Background notification handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  // Handle the notification
  if (message.notification != null) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.hashCode,
        channelKey: 'kumon_practice_reminder',
        title: '<b>${message.notification?.title}</b>',
        body: message.notification?.body,
        color: const Color(0xFF0054A6),
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
        displayOnForeground: true,
        displayOnBackground: true,
        icon: 'resource://mipmap/ic_launcher',
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'PRACTICE_NOW',
          label: 'Practice Now',
          color: const Color(0xFF0054A6),
          actionType: ActionType.Default,
        ),
        NotificationActionButton(
          key: 'REMIND_LATER',
          label: 'Remind Later',
          actionType: ActionType.Default,
        ),
      ],
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'dailyNotification') {
      // Initialize notifications first
      await AwesomeNotifications().initialize(
        'resource://mipmap/ic_launcher',
        [
          NotificationChannel(
            channelKey: 'kumon_practice_reminder',
            channelName: 'Practice Reminder',
            channelDescription: 'Reminds students to practice daily',
            defaultColor: const Color(0xFF0054A6),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            playSound: true,
            enableLights: true,
            enableVibration: true,
          ),
        ],
      );

      // Create the notification after channel is initialized
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: inputData?['id'] ?? 0,
          channelKey: 'kumon_practice_reminder',
          title: '<b>${inputData?['title'] ?? 'Practice Time!'}</b>',
          body: inputData?['body'] ?? 'Time to practice your math skills!',
          color: const Color(0xFF0054A6),
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          displayOnForeground: true,
          displayOnBackground: true,
          icon: 'resource://mipmap/ic_launcher',
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'PRACTICE_NOW',
            label: 'Practice Now',
            color: const Color(0xFF0054A6),
            actionType: ActionType.Default,
          ),
          NotificationActionButton(
            key: 'REMIND_LATER',
            label: 'Remind Later',
            actionType: ActionType.Default,
          ),
        ],
      );
    }
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String activeScreen = 'start_screen';
  List<String> answeredQuestions = [];
  List<bool> answeredCorrectly = [];
  int totalTimeInSeconds = 0;
  Operation _selectedOperation = Operation.addition_2A;
  String _selectedRange = 'Upto +5'; // Default range
  bool _isDarkMode = false; // Flag to manage dark mode
  late FirebaseMessaging messaging;

 @override
  void initState() {
    super.initState();
    setupNotifications();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  Future<void> setupNotifications() async {
    await requestPermissions();

    // Initialize notifications with channel
    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'kumon_practice_reminder',
          channelName: 'Practice Reminder',
          channelDescription: 'Reminds students to practice daily',
          defaultColor: const Color(0xFF0054A6),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
    );

    await FirebaseMessaging.instance.getToken().then((fcmToken) {
      print('FCM Token: $fcmToken');
    });

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notification.hashCode,
            channelKey: 'kumon_practice_reminder',
            title: '<b>${notification.title}</b>',
            body: notification.body,
            color: const Color(0xFF0054A6),
            notificationLayout: NotificationLayout.Default,
            category: NotificationCategory.Reminder,
            wakeUpScreen: true,
            displayOnForeground: true,
            displayOnBackground: true,
            icon: 'resource://mipmap/ic_launcher',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'PRACTICE_NOW',
              label: 'Practice Now',
              color: const Color(0xFF0054A6),
              actionType: ActionType.Default,
            ),
            NotificationActionButton(
              key: 'REMIND_LATER',
              label: 'Remind Later',
              actionType: ActionType.Default,
            ),
          ],
        );
      }
    });
  }

  /// Request notification permissions
  Future<void> requestPermissions() async {
    await Permission.notification.request();

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Initialize local notifications
  Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'kumon_practice_reminder',
          channelName: 'Practice Reminder',
          channelDescription: 'Reminds students to practice daily',
          defaultColor: const Color(0xFF0054A6),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          soundSource: 'resource://raw/notification_sound',
        ),
      ],
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notification.hashCode,
            channelKey: 'kumon_practice_reminder',
            title: '<b>${notification.title}</b>',
            body: notification.body,
            color: const Color(0xFF0054A6),
            notificationLayout: NotificationLayout.Default,
            displayOnForeground: true,
            displayOnBackground: true,
            icon: 'resource://mipmap/ic_launcher',
          ),
        );
      }
    });
  }

  void switchToPracticeScreen(Operation operation, String range) {
    setState(() {
      _selectedOperation = operation;
      _selectedRange = range;
      activeScreen = 'practice_screen';
    });
  }

  void switchToStartScreen() {
    setState(() {
      activeScreen = 'start_screen';
    });
  }

  void switchToResultScreen(
      List<String> questions, List<bool> correctAnswers, int time) {
    setState(() {
      answeredQuestions = questions;
      answeredCorrectly = correctAnswers;
      totalTimeInSeconds = time;
      activeScreen = 'result_screen';
    });
  }

  void triggerTTS(String text, WidgetRef ref) {
    TTSService().speak(text, ref); // Pass WidgetRef to TTSService
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        seedColor: const Color(0xFF009DDC),
        primary: const Color(0xFF009DDC),
        secondary: Colors.red,
        surface: _isDarkMode ? Colors.black : Colors.white,
        onSurface: _isDarkMode ? Colors.white : Colors.black,
        error: Colors.red,
      ),
      textTheme: GoogleFonts.latoTextTheme(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Consumer(
          builder: (context, ref, child) {
            return activeScreen == 'start_screen'
                ? StartScreen(switchToPracticeScreen, switchToStartScreen,
                    toggleDarkMode, isDarkMode: _isDarkMode,  // Pass the dark mode toggle function
                    )
                : activeScreen == 'practice_screen'
                    ? PracticeScreen(
                        (questions, correctAnswers, time) =>
                            switchToResultScreen(
                                questions, correctAnswers, time),
                        switchToStartScreen, // Pass directly as VoidCallback
                        (text) => triggerTTS(text, ref),
                        _selectedOperation,
                        _selectedRange,
                      )
                    : ResultScreen(answeredQuestions, answeredCorrectly,
                        totalTimeInSeconds, switchToStartScreen);
          },
        ),
      ),
    );
  }
}
