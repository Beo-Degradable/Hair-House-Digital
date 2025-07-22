import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  AccountSettingsPage({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account Settings',
              style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          // First Name
          _buildTextField('First Name', firstNameController),

          SizedBox(height: 12),

          // Last Name
          _buildTextField('Last Name', lastNameController),

          SizedBox(height: 12),

          // Email
          _buildTextField('Email', emailController,
              keyboardType: TextInputType.emailAddress),

          SizedBox(height: 20),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.amberAccent, width: 2),
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.black,
              ),
              child: Text('Save Changes',
                  style: TextStyle(
                      color: Colors.amberAccent, fontWeight: FontWeight.bold)),
              onPressed: () {
                // Implement update logic here
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.black87,
                  content: Text('Changes saved successfully!',
                      style: TextStyle(color: Colors.amberAccent)),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amberAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent, width: 2),
        ),
      ),
    );
  }
}
