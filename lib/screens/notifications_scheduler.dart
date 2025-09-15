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

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel_id', // same as in notification details
      'Reminder Notifications',
      description: 'Channel for reminder notifications',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            print('Notification tapped: ${notificationResponse.payload}');
          },
    );

    // Create the channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channel_id',
          'Local Notifications',
          channelDescription: 'Channel for local notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Immediate Notification',
      'This is an immediate notification!',
      notificationDetails,
      payload: 'immediate_notification',
    );
  }

  Future<void> _scheduleNotification() async {
    DateTime now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // If the selected time is in the past, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Convert to timezone DateTime for exact scheduling
    tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'reminder_channel_id',
          'Reminder Notifications',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Generate a unique ID using the scheduled time
    int notificationId = scheduledDate.millisecondsSinceEpoch ~/ 1000;

    try {
      // This will work even when app is closed
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, // Use the unique ID
        'Reminder',
        'Scheduled reminder',
        tzScheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'scheduled_reminder_$notificationId',
      );

      await _checkScheduledNotifications();

      _showSuccessDialog(
        'Reminder set for ${_selectedTime.format(context)} '
        '${scheduledDate.day == now.day ? 'today' : 'tomorrow'}\n'
        'This will work even when the app is closed!',
      );
    } catch (e) {
      _showErrorDialog('Error scheduling notification: $e');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
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
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkScheduledNotifications() async {
    final pendingNotifications = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();

    print('Pending notifications: ${pendingNotifications.length}');
    for (var notification in pendingNotifications) {
      print(
        'ID: ${notification.id}, Title: ${notification.title}, '
        'Scheduled for: ${notification.body}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder App'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Immediate Notification Button
            ElevatedButton(
              onPressed: _showNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Send Test Notification',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30),

            // Schedule Reminder Section
            Text(
              'Set Reminder',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Time Selection
            ListTile(
              title: Text('Time'),
              subtitle: Text(
                _selectedTime.format(context),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 40),

            // Schedule Button
            ElevatedButton(
              onPressed: _scheduleNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Set Reminder',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Clear Notifications Button
            ElevatedButton(
              onPressed: () async {
                await flutterLocalNotificationsPlugin.cancelAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All reminders cleared')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Clear All Reminders',
                style: TextStyle(color: Colors.white),
              ),
            ),

            SizedBox(height: 20),
            Text(
              '✅ Works even when app is closed\n'
              '✅ Exact timing guaranteed\n'
              '✅ Will trigger at the exact time you set',
              style: TextStyle(fontSize: 12, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}