import 'package:flutter/material.dart';
import 'package:hairhouse/pages/package/user_data.dart';
import 'package/widgets/forgottpassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false; // to toggle password visibility

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

                    // login form container
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
                              Text("Login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),

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
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),

                              // forgot password button
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ForgotPasswordPage()),
                                  );
                                },
                                child: Text("Forgot Password?",
                                    style: TextStyle(fontSize: 10)),
                              ),
                              SizedBox(height: 4),

                              // login button logic
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final email = emailController.text.trim();
                                    final password =
                                        passwordController.text.trim();

                                    // validate login using UserData function
                                    final result = await UserData.validateLogin(
                                        email, password);

                                    if (result != null) {
                                      // show error if login fails
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(result)),
                                      );
                                    } else {
                                      // login success
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text("Login successful!")),
                                      );
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    }
                                  }
                                },
                                child: Text("Login",
                                    style: TextStyle(fontSize: 11)),
                              ),
                              SizedBox(height: 6),

                              // sign up redirect button
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/signup');
                                  },
                                  child: Text("Don't have an account? Sign Up",
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
