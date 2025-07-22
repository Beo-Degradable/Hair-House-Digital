import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'bookingtabs/appointmentpage.dart'; // For booking page navigation
import 'bookingtabs/services.dart'; // Access to all available services

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _hasCaptured = false; // True if an image was captured or picked
  File? _image; // Holds the picked image file
  List<Map<String, dynamic>> _recommendedServices =
      []; // Services to recommend based on capture

  // Generates 2-3 random recommended services from allServices
  void _generateServices() {
    final shuffled = List<Map<String, dynamic>>.from(allServices)..shuffle();
    final count = min(3, shuffled.length);

    setState(() {
      _recommendedServices = shuffled.take(count).toList();
    });
  }

  // Simulates taking a picture without using camera
  void _simulateCapture() {
    setState(() {
      _hasCaptured = true;
      _image = null; // No image file when simulating
    });
    _generateServices();
  }

  // Picks an image from gallery using image_picker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _hasCaptured = true;
      });
      _generateServices();
    }
  }

  // Resets capture state to allow retaking
  void _retryCapture() {
    setState(() {
      _hasCaptured = false;
      _image = null;
      _recommendedServices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Camera preview container or captured image
          Container(
            margin: EdgeInsets.all(16),
            height: 400,
            decoration: BoxDecoration(
              color: _hasCaptured ? Colors.black : Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: _hasCaptured
                ? _image != null
                    // Displays picked image
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!,
                            fit: BoxFit.cover, width: double.infinity),
                      )
                    // Shows placeholder text if simulating capture
                    : Center(
                        child: Text('Captured Placeholder',
                            style: TextStyle(color: Colors.white70)))
                : Stack(
                    children: [
                      // Grid overlay vertical and horizontal lines
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            2,
                            (_) =>
                                Divider(color: Colors.white30, thickness: 1)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            2,
                            (_) => VerticalDivider(
                                color: Colors.white30, thickness: 1)),
                      ),
                    ],
                  ),
          ),

          SizedBox(height: 16),

          // Capture, upload, and retry buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_hasCaptured)
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.redAccent),
                  iconSize: 36,
                  onPressed: _retryCapture, // Retry resets capture
                ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _simulateCapture, // Simulate capture button
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), padding: EdgeInsets.all(24)),
                child: Icon(Icons.camera_alt, size: 30),
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.file_upload, color: Colors.blueAccent),
                iconSize: 36,
                onPressed: _pickImage, // Opens gallery to pick image
              ),
            ],
          ),

          SizedBox(height: 20),

          // Shows recommended services after capture
          if (_hasCaptured)
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recommended Services:",
                      style: TextStyle(color: Colors.amber, fontSize: 16)),
                  SizedBox(height: 10),
                  // Lists each recommended service name and price
                  ..._recommendedServices.map((s) => Text(
                      "- ${s['name']} (₱${s['price']})",
                      style: TextStyle(color: Colors.white))),
                  SizedBox(height: 16),

                  // Book Now button navigates to AppointmentPage with recommended services
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _recommendedServices.isNotEmpty
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentPage(
                                    selectedServices: _recommendedServices,
                                    stylists: [], // No stylists passed here
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: Text("Book Now"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 40),
        ],
      ),
    );
  }
}
