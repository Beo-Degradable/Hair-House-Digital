import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms of Service',
            style: TextStyle(
              color: Colors.amberAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                '''
These are your Terms of Service:

1. **Usage Agreement**  
By using this app, you agree to comply with all terms and policies stated.

2. **Accounts**  
You are responsible for maintaining the confidentiality of your account information.

3. **Prohibited Activities**  
You agree not to misuse the app or engage in any activity that disrupts its functionality.

4. **Termination**  
We reserve the right to suspend or terminate your account if terms are violated.

5. **Changes to Terms**  
We may modify these terms at any time. Continued use indicates acceptance of the updated terms.

Please read these terms carefully before using our services.
                ''',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
