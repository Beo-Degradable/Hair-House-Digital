import 'package:flutter/material.dart';
import 'appointmentpage.dart';

class BranchesPage extends StatelessWidget {
  final Map<String, dynamic> branch;

  BranchesPage({required this.branch});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> additionalInfo = {
      'rating': 4.8,
      'promotions': {
        'title': 'Free Haircut for Rebond Package',
        'validUntil': 'August 15, 2025',
      },
      'pictures': [
        'images/verg.png',
        'images/lawas.png',
        'images/luxury.webp',
        'images/lipa.png',
      ],
      'schedule': {
        'Monday': '9:00 AM – 7:00 PM',
        'Tuesday': '9:00 AM – 7:00 PM',
        'Wednesday': 'Closed',
        'Thursday': '9:00 AM – 7:00 PM',
        'Friday': '9:00 AM – 7:00 PM',
        'Saturday': '9:00 AM – 7:00 PM',
        'Sunday': 'Closed',
        'closingToday': '7:00 PM',
      },
    };

    final schedule = additionalInfo['schedule'] as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(branch['name'], style: TextStyle(fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Branch pictures
                  Container(
                    height: 120,
                    margin: EdgeInsets.only(top: 12),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: (additionalInfo['pictures'] as List<String>)
                          .map((pic) {
                        return Padding(
                          padding: EdgeInsets.only(left: 16, right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              pic,
                              width: 200,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Main info container
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Branch image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Image.network(
                              branch['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        SizedBox(height: 18),

                        // Basic info
                        Text(branch['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white)),
                        SizedBox(height: 2),
                        Text(branch['location'],
                            style:
                                TextStyle(fontSize: 10, color: Colors.white70)),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 2),
                            Text('${additionalInfo['rating']}',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white)),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Services
                        Text('Services:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)),
                        SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: List<Widget>.generate(
                            branch['services'].length,
                            (i) => Chip(
                              label: Text(branch['services'][i],
                                  style: TextStyle(fontSize: 10)),
                              backgroundColor: Colors.grey[850],
                              labelStyle: TextStyle(color: Colors.white),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        // Promotions
                        if (additionalInfo['promotions'] != null)
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amberAccent),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Promotion:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.amber[800])),
                                Text(additionalInfo['promotions']['title'],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                Text(
                                  'Valid until: ${additionalInfo['promotions']['validUntil']}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 10),

                        // Schedule
                        Text('Schedule:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)),
                        SizedBox(height: 4),
                        ...schedule.entries.map((entry) {
                          if (entry.key != 'closingToday') {
                            return Text('${entry.key}: ${entry.value}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white70));
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                        Text('Closing Today: ${schedule['closingToday']}',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),

                        SizedBox(height: 10),

                        // Stylists
                        Text('Stylists:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)),
                        SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: List<Widget>.generate(
                            branch['stylists'].length,
                            (index) => Chip(
                              label: Text(branch['stylists'][index],
                                  style: TextStyle(fontSize: 10)),
                              backgroundColor: Colors.grey[850],
                              labelStyle: TextStyle(color: Colors.white),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Schedule button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentPage(
                                    stylists: branch['stylists'],
                                    selectedServices: [],
                                  ),
                                ),
                              );
                            },
                            child: Text('Schedule Appointment',
                                style: TextStyle(fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
