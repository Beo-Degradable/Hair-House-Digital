import 'package:flutter/material.dart';
import 'package:hairhouse/pages/package/user_data.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false; // controls password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/SLbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // dark overlay for readability
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 50),

                    // app logo
                    Center(
                      child: Image.asset(
                        'images/sign.png',
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 10),

                    // signup form container
                    Center(
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Sign Up",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),

                              // first and last name inputs side by side
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                          labelText: 'First Name'),
                                      style: TextStyle(fontSize: 11),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter first name'
                                              : null,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                          labelText: 'Last Name'),
                                      style: TextStyle(fontSize: 11),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter last name'
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),

                              // email input
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(labelText: 'Email'),
                                style: TextStyle(fontSize: 11),
                                validator: (value) {
                                  if (value == null || !value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),

                              // password input with show/hide toggle
                              TextFormField(
                                controller: passwordController,
                                obscureText: !showPassword,
                                style: TextStyle(fontSize: 11),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return 'Minimum 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 4),

                              // sign up button logic
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // save user data to storage
                                    await UserData.saveCredentials(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      firstName:
                                          firstNameController.text.trim(),
                                      lastName: lastNameController.text.trim(),
                                    );

                                    // show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Account created. Please log in.")),
                                    );

                                    // navigate to login page
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => LoginPage()),
                                    );
                                  }
                                },
                                child: Text("Sign Up",
                                    style: TextStyle(fontSize: 11)),
                              ),
                              SizedBox(height: 6),

                              // social signup buttons (currently not functional)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.g_mobiledata, size: 14),
                                      label: Text("Google",
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.apple, size: 14),
                                      label: Text("Apple",
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),

                              // redirect to login page if user already has an account
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => LoginPage()),
                                    );
                                  },
                                  child: Text("Already have an account? Login",
                                      style: TextStyle(fontSize: 10)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
