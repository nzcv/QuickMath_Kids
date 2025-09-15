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
      'Daily Reminders',
      description: 'Channel for daily reminder notifications',
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

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminder_channel_id',
      'Daily Reminders',
      channelDescription: 'Channel for daily reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    int notificationId = scheduledDate.millisecondsSinceEpoch ~/ 1000;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Daily Reminder',
        'Your daily reminder!',
        tzScheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'daily_reminder_$notificationId',
        matchDateTimeComponents: DateTimeComponents.time, // For daily recurrence
      );

      await _loadPendingNotifications();

      _showSuccessDialog(
        'Daily reminder set for ${_selectedTime.format(context)}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Reminder App'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Selection
            Text(
              'Set Daily Reminder',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Time'),
              subtitle: Text(
                _selectedTime.format(context),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 20),

            // Schedule Button
            ElevatedButton(
              onPressed: _scheduleDailyNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Set Daily Reminder',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Clear Notifications Button
            ElevatedButton(
              onPressed: () async {
                await flutterLocalNotificationsPlugin.cancelAll();
                await _loadPendingNotifications();
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

            // Scheduled Notifications List
            Text(
              'Scheduled Reminders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _pendingNotifications.isEmpty
                  ? Center(child: Text('No reminders scheduled'))
                  : ListView.builder(
                      itemCount: _pendingNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _pendingNotifications[index];
                        final scheduledTime = DateTime.fromMillisecondsSinceEpoch(
                            notification.id * 1000);
                        return ListTile(
                          title: Text(notification.title ?? 'Reminder'),
                          subtitle: Text(
                              'Daily at ${TimeOfDay.fromDateTime(scheduledTime).format(context)}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await flutterLocalNotificationsPlugin
                                  .cancel(notification.id);
                              await _loadPendingNotifications();
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}