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
              title: Text(
                'Time: ${selectedTime.format(context)}',
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.access_time, color: Colors.blue),
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
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
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
            child: const Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 10,
        shadowColor: Colors.blue.withOpacity(0.5),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Notification Schedule',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => notificationService
                            .scheduleNotifications(notificationSchedule),
                        icon: const Icon(Icons.notification_add, color: Colors.white),
                        label: const Text(
                          'Schedule All Notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
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
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                'Time: ${time.format(context)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(Icons.edit, color: Colors.blue),
                              onTap: () => _addOrEditNotification(time, index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNotification(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
    );
  }
}