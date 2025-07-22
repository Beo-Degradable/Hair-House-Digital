import 'package:flutter/material.dart';
import 'appointmentpage.dart'; // Adjust path if needed

final List<Map<String, dynamic>> allServices = [
  {
    'name': 'Haircut',
    'desc': 'Classic cut by expert stylists.',
    'price': '200',
    'image': 'images/haircut.webp',
    'category': 'hair',
  },
  {
    'name': 'Brazillian',
    'desc': 'Smoothens and removes frizz.',
    'price': '1499',
    'image': 'images/brazilian.jpg',
    'category': 'hair',
  },
  {
    'name': 'Highlights',
    'desc': 'Adds colored streaks for dimension.',
    'price': '1499',
    'image': 'images/highlights.jpg',
    'category': 'hair',
  },
  {
    'name': 'Keratin Treatment',
    'desc': 'Smoothens and adds shine.',
    'price': '999',
    'image': 'images/keratin.jpg',
    'category': 'hair',
  },
  {
    'name': 'Monotone Color',
    'desc': 'Single full hair color.',
    'price': '1499',
    'image': 'images/monotone.jpg',
    'category': 'hair',
  },
  {
    'name': 'Manicure',
    'desc': 'Relaxing nail care session.',
    'price': '250',
    'image': 'images/manicure.jpg',
    'category': 'nails',
  },
  {
    'name': 'Gel Polish',
    'desc': 'Long-lasting and shiny.',
    'price': '400',
    'image': 'images/gel.jpg',
    'category': 'nails',
  },
  {
    'name': 'Pedicure',
    'desc': 'Nail cleaning + polish (feet).',
    'price': '250',
    'image': 'images/pedicure.jpg',
    'category': 'nails',
  },
  {
    'name': 'Facial Treatment',
    'desc': 'Deep cleansing and hydration.',
    'price': '700',
    'image': 'images/facial.jpg',
    'category': 'skin',
  },
  {
    'name': 'Underarm Whitening/Laser',
    'desc': 'Lightens skin and removes hair.',
    'price': '3200',
    'image': 'images/underarm.jpg',
    'category': 'skin',
  },
];

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String selectedBranch = 'Vergara';
  String selectedCategory = 'All';
  bool selectionMode = false;
  Set<int> selectedIndexes = {};

  final Map<String, List<String>> branchCategories = {
    'Vergara': ['All', 'hair', 'nails'],
    'Lawas': ['All', 'hair', 'nails'],
    'Lipa': ['All', 'hair', 'nails', 'skin'],
    'Tanauan': ['All', 'hair', 'nails'],
  };

  List<Map<String, dynamic>> get filteredServices {
    final allowedCategories = branchCategories[selectedBranch]!;
    if (selectedCategory == 'All') {
      return allServices
          .where((s) => allowedCategories.contains(s['category']))
          .toList();
    }
    return allServices.where((s) => s['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Please select branch:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (selectionMode)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectionMode = false;
                        selectedIndexes.clear();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black54, shape: BoxShape.circle),
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: branchCategories.keys.map((branch) {
                  final isSelected = selectedBranch == branch;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBranch = branch;
                        selectedCategory = 'All';
                        selectionMode = false;
                        selectedIndexes.clear();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        branch,
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 16),

            // Category filter
            Text('Services:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: branchCategories[selectedBranch]!.map((category) {
                final isSelected = selectedCategory == category;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        selectionMode = false;
                        selectedIndexes.clear();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          category.toUpperCase(),
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 2
                          : 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final service = filteredServices[index];
                  final isSelected = selectedIndexes.contains(index);

                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        selectionMode = true;
                        selectedIndexes.add(index);
                      });
                    },
                    onTap: selectionMode
                        ? () {
                            setState(() {
                              if (isSelected) {
                                selectedIndexes.remove(index);
                                if (selectedIndexes.isEmpty)
                                  selectionMode = false;
                              } else {
                                selectedIndexes.add(index);
                              }
                            });
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amberAccent : Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected ? Colors.amber : Colors.black),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                service['image'],
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              service['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              service['desc'],
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '₱${service['price']}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer(),
                          if (!selectionMode)
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentPage(
                                        selectedServices: [service],
                                        stylists: [],
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Book'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Floating action button for booking selected services
        if (selectionMode && selectedIndexes.isNotEmpty)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () {
                final selectedServices =
                    selectedIndexes.map((i) => filteredServices[i]).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentPage(
                      selectedServices: selectedServices,
                      stylists: [],
                    ),
                  ),
                );
              },
              label: Text('Book Selected'),
              icon: Icon(Icons.check),
            ),
          ),
      ],
    );
  }
}
