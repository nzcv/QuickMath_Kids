import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationDemo extends StatefulWidget {
  @override
  _NotificationDemoState createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<PendingNotificationRequest> _pendingNotifications = [];

  // List of motivational messages
  final List<String> _motivationalMessages = [
    'Keep pushing forward, you’ve got this!',
    'Today is your day to shine!',
    'Stay focused and make it happen!',
    'You’re stronger than you know!',
    'Seize the moment and achieve greatness!',
    'Every step you take is progress!',
    'Believe in yourself and soar!',
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones();
    _loadPendingNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel_id',
      'Daily Motivation',
      description: 'Channel for daily motivational reminders',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        print('Notification tapped: ${notificationResponse.payload}');
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  String _getRandomMotivationalMessage() {
    final random = Random();
    return _motivationalMessages[random.nextInt(_motivationalMessages.length)];
  }

  Future<void> _scheduleDailyNotification() async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    final motivationalMessage = _getRandomMotivationalMessage();

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminder_channel_id',
      'Daily Motivation',
      channelDescription: 'Channel for daily motivational reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    int notificationId = scheduledDate.millisecondsSinceEpoch ~/ 1000;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Daily Motivation',
        motivationalMessage,
        tzScheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'daily_reminder_$notificationId',
        matchDateTimeComponents: DateTimeComponents.time,
      );

      await _loadPendingNotifications();

      _showSuccessDialog(
        'Daily motivational reminder set for ${_selectedTime.format(context)}',
      );
    } catch (e) {
      _showErrorDialog('Error scheduling notification: $e');
    }
  }

  Future<void> _loadPendingNotifications() async {
    final pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    setState(() {
      _pendingNotifications = pendingNotifications;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.tealAccent,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Motivation App'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Motivational Header
              const Center(
                child: Text(
                  'Stay Inspired Every Day!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Time Selection
              const Text(
                'Set Your Daily Motivation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: const Text('Time'),
                  subtitle: Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.access_time, color: Colors.teal),
                  onTap: () => _selectTime(context),
                ),
              ),
              const SizedBox(height: 20),

              // Schedule Button
              ElevatedButton(
                onPressed: _scheduleDailyNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Set Daily Motivation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Clear Notifications Button
              ElevatedButton(
                onPressed: () async {
                  await flutterLocalNotificationsPlugin.cancelAll();
                  await _loadPendingNotifications();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All reminders cleared')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Clear All Reminders',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Scheduled Notifications List
              const Text(
                'Your Scheduled Motivations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _pendingNotifications.isEmpty
                    ? const Center(
                        child: Text(
                          'No motivations scheduled yet!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _pendingNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = _pendingNotifications[index];
                          final scheduledTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  notification.id * 1000);
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(notification.title ?? 'Motivation'),
                              subtitle: Text(
                                'Daily at ${TimeOfDay.fromDateTime(scheduledTime).format(context)}\n${notification.body}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () async {
                                  await flutterLocalNotificationsPlugin
                                      .cancel(notification.id);
                                  await _loadPendingNotifications();
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}