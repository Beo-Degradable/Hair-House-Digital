import 'package:flutter/material.dart';
import 'package:hairhouse/pages/bookingtabs/branchdetail.dart';

class BookingTabPage extends StatelessWidget {
  final List<Map<String, dynamic>> branches = [
    {
      'name': 'Hair House Salon',
      'location': '23A Evalista St, Poblacion, Batangas City, 4200 Batangas',
      'services': ['Hair', 'Nail'],
      'image': 'images/verg.png',
      'stylists': ['Stylist A', 'Stylist B', 'Stylist C'],
    },
    {
      'name': 'Hair House Lawas Branch',
      'location':
          '2F Junction Commercial Complex, P. Burgos, Batangas City, 4200 Batangas',
      'services': ['Hair', 'Nail', 'Skin'],
      'image': 'images/lawas.png',
      'stylists': ['Stylist D', 'Stylist E'],
    },
    {
      'name': 'Hair House Salon Luxury',
      'location': 'Lipa City, 4217 Batangas',
      'services': ['Hair', 'Skin'],
      'image': 'images/luxury.webp',
      'stylists': ['Stylist F', 'Stylist G', 'Stylist H'],
    },
    {
      'name': 'Hair House Salon',
      'location': 'Esteban Mayo St, Lipa City, 4217 Batangas',
      'services': ['Hair', 'Nail'],
      'image': 'images/lipa.png',
      'stylists': ['Stylist I', 'Stylist J'],
    },
    {
      'name': 'Hair House Salon',
      'location':
          '225 President Jose P. Laurel Highway, Tanauan City, Batangas',
      'services': ['Hair', 'Nail', 'Skin'],
      'image': 'https://via.placeholder.com/150',
      'stylists': ['Stylist K', 'Stylist L', 'Stylist M'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C), // Dark background color
      appBar: AppBar(
        title: Text('Booking'),
        backgroundColor: Colors.amber[700],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          int crossAxisCount = orientation == Orientation.portrait ? 2 : 3;

          return GridView.builder(
            padding: EdgeInsets.all(16),
            itemCount: branches.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final branch = branches[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BranchesPage(branch: branch),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // Card background color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          branch['image'],
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 4),
                            Text(
                              branch['location'],
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              children: List<Widget>.generate(
                                branch['services'].length,
                                (serviceIndex) => Chip(
                                  label: Text(
                                    branch['services'][serviceIndex],
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: Colors.black54,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
