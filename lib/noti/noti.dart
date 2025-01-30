import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (task == 'dailyNotification') {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'daily_notifications_channel',
        'Daily Notifications',
        channelDescription: 'Channel for daily scheduled notifications',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      final String notificationTitle =
          inputData?['title'] ?? 'Scheduled Notification';
      final String notificationBody =
          inputData?['body'] ?? 'Time for your daily notification!';
      final int notificationId = inputData?['id'] ?? 0;

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        notificationTitle,
        notificationBody,
        platformChannelSpecifics,
      );
    }

    return Future.value(true);
  });
}

class NotificationSettings extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onScheduleUpdate;
  final List<Map<String, dynamic>> initialSchedule;

  const NotificationSettings({
    super.key,
    required this.onScheduleUpdate,
    required this.initialSchedule,
  });

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  List<Map<String, dynamic>> notificationSchedule = [];

  @override
  void initState() {
    super.initState();
    notificationSchedule = List<Map<String, dynamic>>.from(widget.initialSchedule);
  }

  Future<void> saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleJson = json.encode(
      notificationSchedule.map((item) => {
        'hour': item['time'].hour,
        'minute': item['time'].minute,
        'title': item['title'],
      }).toList(),
    );
    await prefs.setString('notification_schedule', scheduleJson);
    widget.onScheduleUpdate(notificationSchedule);
  }

  Future<void> _addOrEditNotification([Map<String, dynamic>? existing, int? index]) async {
    TimeOfDay selectedTime = existing?['time'] ?? TimeOfDay.now();
    String title = existing?['title'] ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Notification' : 'Edit Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(labelText: 'Notification Title'),
              onChanged: (value) => title = value,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Time: ${selectedTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) {
                  selectedTime = picked;
                  (context as Element).markNeedsBuild();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty) {
                setState(() {
                  final newSchedule = {
                    'time': selectedTime,
                    'title': title,
                  };
                  if (existing == null) {
                    notificationSchedule.add(newSchedule);
                  } else {
                    notificationSchedule[index!] = newSchedule;
                  }
                });
                saveSchedule();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Column(
        children: [
          Expanded(
            child: notificationSchedule.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications scheduled\nTap + to add a notification',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: notificationSchedule.length,
                    itemBuilder: (context, index) {
                      final schedule = notificationSchedule[index];
                      return ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(schedule['title']),
                        subtitle: Text('Time: ${schedule['time'].format(context)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _addOrEditNotification(schedule, index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  notificationSchedule.removeAt(index);
                                });
                                saveSchedule();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNotification(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late FirebaseMessaging messaging;
  String? fcmToken;
  List<Map<String, dynamic>> notificationSchedule = [];

  @override
  void initState() {
    super.initState();
    setupNotifications();
    loadSchedule(); // Load saved schedule on startup
  }

  Future<void> loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleJson = prefs.getString('notification_schedule');
    if (scheduleJson != null) {
      final List<dynamic> decoded = json.decode(scheduleJson);
      setState(() {
        notificationSchedule = decoded
            .map((item) => {
                  'time': TimeOfDay(
                    hour: item['hour'] as int,
                    minute: item['minute'] as int,
                  ),
                  'title': item['title'] as String,
                })
            .toList();
      });
    }
  }

  Future<void> setupNotifications() async {
    await requestPermissions();
    await initializeNotifications();
    await getFCMToken();
  }

  Future<void> requestPermissions() async {
    await Permission.notification.request();

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> getFCMToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');
  }

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    messaging = FirebaseMessaging.instance;
  }

  void updateSchedule(List<Map<String, dynamic>> newSchedule) {
    setState(() {
      notificationSchedule = newSchedule;
    });
    scheduleNotifications(); // Reschedule notifications with new times
  }

  Future<void> scheduleNotifications() async {
    if (notificationSchedule.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No notifications scheduled'),
        ),
      );
      return;
    }

    // Cancel any existing notifications
    await Workmanager().cancelAll();

    for (int i = 0; i < notificationSchedule.length; i++) {
      final schedule = notificationSchedule[i];
      final TimeOfDay notificationTime = schedule['time'];

      // Calculate the initial delay until the next occurrence of the specified time
      final now = DateTime.now();
      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        notificationTime.hour,
        notificationTime.minute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final initialDelay = scheduledTime.difference(now);

      // Register the daily task
      await Workmanager().registerPeriodicTask(
        'daily_notification_$i',
        'dailyNotification',
        frequency: const Duration(days: 1),
        initialDelay: initialDelay,
        inputData: {
          'id': i,
          'title': schedule['title'],
          'body':
              'Your daily notification at ${notificationTime.format(context)}',
        },
        constraints: Constraints(
          networkType: NetworkType.not_required,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily notifications scheduled'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Notifications Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationSettings(
                    onScheduleUpdate: updateSchedule,
                    initialSchedule: notificationSchedule,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: scheduleNotifications,
              child: const Text('Schedule Daily Notifications'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                notificationSchedule.isEmpty
                    ? 'No notifications scheduled'
                    : 'Scheduled notifications:\n${notificationSchedule.map((schedule) => '${schedule['title']} at ${schedule['time'].format(context)}').join('\n')}',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
