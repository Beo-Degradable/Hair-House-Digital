import 'package:flutter/material.dart';
import 'settings_pages/account_settings.dart';
import 'settings_pages/privacy_policy.dart';
import 'settings_pages/terms_of_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget? _currentPage; // null means showing main settings
  String _appBarTitle = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_appBarTitle),
        backgroundColor: Colors.amber[700],
        leading: _currentPage != null
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentPage = null;
                    _appBarTitle = 'Settings'; // Reset title when going back
                  });
                },
              )
            : null,
      ),
      body: _currentPage ?? _buildSettingsList(),
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      children: [
        _buildSettingTile(
            Icons.lock,
            'Account Settings',
            AccountSettingsPage(
              firstName: '',
              lastName: '',
              email: '',
            )),
        _buildSettingTile(
            Icons.privacy_tip, 'Privacy Policy', PrivacyPolicyPage()),
        _buildSettingTile(
            Icons.description, 'Terms of Service', TermsOfServicePage()),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.amberAccent),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
      onTap: () {
        setState(() {
          _currentPage = page;
          _appBarTitle = title; // Change AppBar title to current page
        });
      },
    );
  }
}
