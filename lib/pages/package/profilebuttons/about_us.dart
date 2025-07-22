import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.amber[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.amber[200],
                backgroundImage:
                    AssetImage('assets/logo.png'), // replace with your asset
              ),
            ),
            SizedBox(height: 20),

            // Salon name
            Center(
              child: Text(
                'Hai House Salon',
                style: TextStyle(
                  color: Colors.amber[200],
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Tagline
            Center(
              child: Text(
                '“Elevate your Expectations”',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 24),

            // About description
            Text(
              'About Us',
              style: TextStyle(
                color: Colors.amber[300],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Hai House Salon is your trusted beauty destination in Batangas City, known for exceptional hair services, professional consultations, and a relaxing experience every visit. Our skilled stylists ensure you walk out confidently and satisfied.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),

            // Branches section
            Text(
              'Our Branches',
              style: TextStyle(
                color: Colors.amber[300],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),

            // Branch 1
            branchCard(
              context,
              branchName: 'Batangas City Branch',
              address:
                  '2F Junction Commercial Complex, P. Burgos, Batangas City, 4200 Batangas',
              phone: ' (043) 722 3902',
              hours: 'Sunday – Saturday: 8:00 AM – 5:00 PM',
            ),
            SizedBox(height: 12),

            // Branch 2 example
            branchCard(
              context,
              branchName: 'Batangas City Branch',
              address:
                  '23A Evangelista St, Poblacion, Batangas City, 4200 Batangas',
              phone: '(043) 722 3902',
              hours: 'Monday – Sunday: 10:00 AM – 8:00 PM',
            ),
            SizedBox(height: 24),

            branchCard(
              context,
              branchName: 'Lipa City Branch',
              address: 'Robinsons Place Lipa, Lipa City, Batangas',
              phone: '(043) 756 1234',
              hours: 'Monday – Sunday: 10:00 AM – 8:00 PM',
            ),
            SizedBox(height: 24),

            branchCard(
              context,
              branchName: 'Hair House Salon Esteban Mayo Lipa Branch',
              address: 'Esteban Mayo St, Lipa City, 4217 Batangas',
              phone: '(043) 404 5425',
              hours: 'Monday – Sunday: 10:00 AM – 8:00 PM',
            ),
            SizedBox(height: 24),

            // Contact us CTA
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.phone, color: Colors.black),
                label: Text('Contact Us'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.amber[500],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  // Implement dial logic or contact page navigation here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget branchCard(
    BuildContext context, {
    required String branchName,
    required String address,
    required String phone,
    required String hours,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[700]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branchName,
            style: TextStyle(
              color: Colors.amber[200],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.amber, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.amber, size: 16),
              SizedBox(width: 8),
              Text(
                phone,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.amber, size: 16),
              SizedBox(width: 8),
              Text(
                hours,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
