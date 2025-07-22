import 'package:flutter/material.dart';

// ✅ Global list to store notifications across the app
List<String> notifications = [];

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // ✅ Clear notifications when this page opens so the badge disappears after viewing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        notifications.clear(); // clear the global notifications list
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Check if there are notifications to show
    bool hasNotif = notifications.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black, // dark theme background
      appBar: AppBar(
        backgroundColor:
            Colors.amber[700], // amber app bar for brand consistency
        title: Text('Notifications'), // page title
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: notifications.isEmpty
                // ✅ If no notifications, show a centered text message
                ? Center(
                    child: Text(
                      'No notifications yet.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  )
                // ✅ If notifications exist, build a ListView of them
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color: Colors.amberAccent, // notification icon color
                        ),
                        title: Text(
                          notifications[index], // show notification message
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
