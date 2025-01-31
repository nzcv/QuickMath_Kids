// main.dart
import 'package:flutter/material.dart';
import 'noti_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationTestScreen(),
    );
  }
}

class NotificationTestScreen extends StatefulWidget {
  @override
  _NotificationTestScreenState createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final NotificationService notificationService = NotificationService();
  List<Map<String, dynamic>> notificationSchedule = [];

  @override
  void initState() {
    super.initState();
    notificationService.initialize();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    notificationSchedule = await notificationService.loadSchedule();
    setState(() {});
  }

  void updateSchedule(List<Map<String, dynamic>> newSchedule) {
    setState(() {
      notificationSchedule = newSchedule;
    });
    notificationService.scheduleNotifications(newSchedule);
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
              onPressed: () => notificationService.scheduleNotifications(notificationSchedule),
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