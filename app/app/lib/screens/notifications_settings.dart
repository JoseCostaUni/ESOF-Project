import 'package:flutter/material.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _currentIndex = 3;
  bool _receiveNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _receiveNotifications = prefs.getBool('receive_notifications') ?? true;
    });
  }

  Future<void> _saveNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('receive_notifications', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(top: 20.0),
                  iconSize: 40,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Receive Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                ListTile(
                  title: const Text('On'),
                  subtitle: const Text('Receive notifications'),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: _receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        _receiveNotifications = value!;
                        _saveNotificationPreference(value);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Off'),
                  subtitle: const Text('Don\'t receive notifications'),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: _receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        _receiveNotifications = value!;
                        _saveNotificationPreference(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
