import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationInit {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _setupNotifications();
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");

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

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      if (task == 'dailyNotification') {
        await _setupNotifications();
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

  static Future<void> _setupNotifications() async {
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

  static Future<void> requestPermissions() async {
    await Permission.notification.request();
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
