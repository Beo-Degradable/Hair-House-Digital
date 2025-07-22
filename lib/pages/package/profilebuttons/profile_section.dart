import 'package:flutter/material.dart';
import 'package:hairhouse/pages/package/user_data.dart';

class ProfileSection extends StatefulWidget {
  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firstName = await UserData.getFirstName() ?? '';
    final lastName = await UserData.getLastName() ?? '';
    final email = await UserData.getEmail() ?? '';

    setState(() {
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _emailController.text = email;
    });
  }

  void _toggleEditSave() async {
    if (isEditing) {
      // Save changes to UserData
      await UserData.setFirstName(_firstNameController.text);
      await UserData.setLastName(_lastNameController.text);
      await UserData.setEmail(_emailController.text);

      Navigator.pop(context, {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.amber[700],
        ),
      );
    } else {
      // Switch to edit mode
      setState(() {
        isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEditSave,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amberAccent,
              child: Text(
                _firstNameController.text.isNotEmpty
                    ? _firstNameController.text[0].toUpperCase()
                    : '?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildField('First Name', _firstNameController, isEditing),
          _buildField('Last Name', _lastNameController, isEditing),
          _buildField('Email', _emailController, isEditing,
              keyboardType: TextInputType.emailAddress),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
            ),
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            label: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
            onPressed: _toggleEditSave,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, bool editable,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.amberAccent, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        editable
            ? TextField(
                controller: controller,
                keyboardType: keyboardType,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  controller.text,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
        SizedBox(height: 12),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
