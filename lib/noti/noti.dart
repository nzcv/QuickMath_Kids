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
  List<TimeOfDay> notificationSchedule = [];

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
          .map((time) => {
                'hour': time.hour,
                'minute': time.minute,
              })
          .toList(),
    );
    await prefs.setString('notification_schedule', scheduleJson);
    notificationService.scheduleNotifications(notificationSchedule);
  }

  Future<void> _addOrEditNotification([TimeOfDay? existing, int? index]) async {
    TimeOfDay selectedTime = existing ?? TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Notification' : 'Edit Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              setState(() {
                if (existing == null) {
                  notificationSchedule.add(selectedTime);
                } else {
                  notificationSchedule[index!] = selectedTime;
                }
              });
              saveSchedule();
              Navigator.pop(context);
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
                      final time = notificationSchedule[index];
                      return Dismissible(
                        key: Key(time.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          final deletedTime = notificationSchedule[index];
                          final deletedIndex = index;

                          setState(() {
                            notificationSchedule.removeAt(index);
                          });
                          saveSchedule();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Notification at ${deletedTime.format(context)} deleted'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  setState(() {
                                    notificationSchedule.insert(
                                        deletedIndex, deletedTime);
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
                            subtitle: Text('Time: ${time.format(context)}'),
                            onTap: () => _addOrEditNotification(time, index),
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