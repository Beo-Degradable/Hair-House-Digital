import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hairhouse/pages/login.dart';
import 'profile_section.dart';
import 'purchased.dart';
import 'about_us.dart';
import 'settings.dart';

class MyDrawer extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;

  const MyDrawer({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = '$firstName $lastName';

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            SizedBox(height: 40),
            CircleAvatar(radius: 40, backgroundColor: Colors.purple[100]),
            SizedBox(height: 8),
            Center(
              child: Text(
                userName.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Center(
              child: Text(
                email,
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.amberAccent),
            navItem(
              context,
              Icons.account_circle,
              'Profile',
              ProfileSection(),
            ),
            navItem(context, Icons.shopping_bag, 'Purchase', PurchasedPage()),
            navItem(context, Icons.info_outline, 'About Us', AboutUsPage()),
            navItem(context, Icons.settings, 'Settings', SettingsPage()),
            Divider(color: Colors.amberAccent),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent, size: 20),
              title: Text('Logout',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Text("Confirm Logout",
                          style: TextStyle(color: Colors.amberAccent)),
                      content: Text("Are you sure you want to log out?",
                          style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel",
                              style: TextStyle(color: Colors.amberAccent)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text("Confirm",
                              style: TextStyle(color: Colors.amberAccent)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(
      BuildContext context, IconData icon, String label, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.amberAccent),
      title: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer

        // Show as modal overlay with blurred background
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    padding: EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 500),
                      child: page,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
