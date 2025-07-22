import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Policy',
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
This is where your Privacy Policy details will go.

1. **Data Collection**  
We collect your personal information for account management, service provision, and security purposes.

2. **Usage**  
Your data will be used solely for the functionality of this app and will not be shared with third parties without consent.

3. **Security**  
We implement best practices to protect your information.

4. **Changes**  
We may update this policy and will notify you of significant changes.

Please read and understand this policy to know how we handle your data.
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
