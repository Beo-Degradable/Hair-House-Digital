import 'package:flutter/material.dart';
import 'package:hairhouse/pages/login.dart';
import 'package:hairhouse/pages/package/user_data.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool emailVerified = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  void verifyEmail() async {
    final storedEmail = await UserData.getEmail();
    if (emailController.text.trim() == storedEmail) {
      setState(() {
        emailVerified = true;
        errorMessage = null;
      });
    } else {
      setState(() {
        errorMessage = 'Email not found.';
        emailVerified = false;
      });
    }
  }

  void resetPassword() async {
    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      setState(() {
        errorMessage = 'Passwords do not match.';
      });
      return;
    }

    if (newPasswordController.text.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters.';
      });
      return;
    }

    await UserData.updatePassword(newPasswordController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password reset successful. Please log in.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Step 1: Email Verification
                  if (!emailVerified) ...[
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter your registered email',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: verifyEmail,
                      child:
                          Text("Verify Email", style: TextStyle(fontSize: 12)),
                    ),
                  ]

                  // Step 2: Password Reset
                  else ...[
                    TextField(
                      controller: newPasswordController,
                      obscureText: !showNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showNewPassword = !showNewPassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: !showConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: resetPassword,
                      child: Text("Reset Password",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],

                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
