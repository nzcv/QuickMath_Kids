import 'package:flutter/material.dart';
import 'noti_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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

  Future<void> saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleJson = json.encode(
      notificationSchedule
          .map((item) => {
                'hour': item['time'].hour,
                'minute': item['time'].minute,
                'title': item['title'],
              })
          .toList(),
    );
    await prefs.setString('notification_schedule', scheduleJson);
    notificationService.scheduleNotifications(notificationSchedule);
  }

  Future<void> _addOrEditNotification(
      [Map<String, dynamic>? existing, int? index]) async {
    TimeOfDay selectedTime = existing?['time'] ?? TimeOfDay.now();
    String title = existing?['title'] ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(existing == null ? 'Add Notification' : 'Edit Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: title,
              decoration:
                  const InputDecoration(labelText: 'Notification Title'),
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
        title: const Text('Daily Notifications'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Notification Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => notificationService
                          .scheduleNotifications(notificationSchedule),
                      icon: const Icon(Icons.notification_add),
                      label: const Text('Schedule All Notifications'),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                      return Dismissible(
                        key: Key(schedule['title']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          // Store the deleted notification temporarily
                          final deletedNotification =
                              notificationSchedule[index];
                          final deletedIndex = index;

                          // Remove the notification from the list
                          setState(() {
                            notificationSchedule.removeAt(index);
                          });
                          saveSchedule();

                          // Show a SnackBar with an "Undo" action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Notification "${deletedNotification['title']}" deleted'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  // Restore the deleted notification
                                  setState(() {
                                    notificationSchedule.insert(
                                        deletedIndex, deletedNotification);
                                  });
                                  saveSchedule();
                                },
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(schedule['title']),
                            subtitle: Text(
                                'Time: ${schedule['time'].format(context)}'),
                            onTap: () =>
                                _addOrEditNotification(schedule, index),
                          ),
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
