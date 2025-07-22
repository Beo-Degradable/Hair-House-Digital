import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';
import 'services.dart'; // Adjust import path if needed

class AppointmentPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedServices;
  final List<dynamic> stylists;

  AppointmentPage({
    required this.selectedServices,
    required this.stylists,
  });

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String? selectedStylist;
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;

  String selectedCategory = 'All';
  bool selectionMode = false;
  Set<int> selectedServiceIndexes = {};

  bool showOtherBranchStylists = false;

  List<String> popularStylists = ['Stylist X', 'Stylist Y'];

  List<String> fullDaySlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  Map<String, List<Map<String, dynamic>>> generatedAppointments = {};

  List<Map<String, dynamic>> get filteredServices {
    if (selectedCategory == 'All') return allServices;
    return allServices
        .where((s) =>
            s['category'].toString().toLowerCase() ==
            selectedCategory.toLowerCase())
        .toList();
  }

  void addService(Map<String, dynamic> service) {
    setState(() {
      widget.selectedServices.add(service);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentStylists =
        showOtherBranchStylists ? popularStylists : widget.stylists;

    List<Map<String, dynamic>> dayAppointments = [];
    if (selectedStylist != null) {
      String key =
          '${selectedStylist}_${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      if (!generatedAppointments.containsKey(key)) {
        dayAppointments = generateRandomAppointments();
        generatedAppointments[key] = dayAppointments;
      } else {
        dayAppointments = generatedAppointments[key]!;
      }
    }

    int estimatedTotal = widget.selectedServices.fold(0, (sum, service) {
      return sum + (service['price'] as int);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (selectionMode)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  selectionMode = false;
                  selectedServiceIndexes.clear();
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stylists section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Choose stylist:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showOtherBranchStylists = !showOtherBranchStylists;
                    });
                  },
                  child: Text('Choose stylist from another branch'),
                ),
              ],
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: currentStylists.map((stylist) {
                  final stylistName = stylist is String
                      ? stylist
                      : stylist['name']; // Adjust if stylist is Map
                  final isSelected = selectedStylist == stylistName;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStylist = stylistName;
                        selectedTimeSlot = null;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                isSelected ? Colors.amber : Colors.grey[300],
                            child: Text(
                              stylistName[0],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(stylistName),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 16),

            // Booked services display
            Text('Booked Services:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.selectedServices.length,
              itemBuilder: (context, index) {
                final service = widget.selectedServices[index];
                return ListTile(
                  leading:
                      Image.network(service['image'], width: 40, height: 40),
                  title: Text(service['name']),
                  subtitle:
                      Text('₱${service['price']} - ${service['duration']}'),
                );
              },
            ),

            SizedBox(height: 16),

            // Services filter buttons
            Text('Add More Services:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Row(
              children: ['All', 'hair', 'nails', 'skin'].map((cat) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedCategory == cat ? Colors.amber : Colors.grey,
                    ),
                    child: Text(cat),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 8),

            // Services horizontal scroll (all services filtered)
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final service = filteredServices[index];
                  return GestureDetector(
                    onTap: () {
                      addService(service);
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(service['image'],
                              height: 50, width: 50),
                          SizedBox(height: 4),
                          Text(service['name'], style: TextStyle(fontSize: 12)),
                          Text('₱${service['price']}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Calendar
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                  selectedTimeSlot = null;
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration:
                    BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                selectedDecoration:
                    BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              ),
            ),

            SizedBox(height: 16),

            // Time slots
            Text(
              selectedStylist != null
                  ? 'Appointments for $selectedStylist on ${selectedDate.day} ${_monthName(selectedDate.month)}'
                  : 'Please select a stylist to view available slots.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (selectedStylist != null)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: fullDaySlots.length,
                itemBuilder: (context, index) {
                  final slot = fullDaySlots[index];
                  final appointment = dayAppointments.firstWhere(
                    (a) => a['time'] == slot,
                    orElse: () => {},
                  );

                  if (appointment.isNotEmpty) {
                    return ListTile(
                      leading: Icon(
                        appointment['status'] == 'Done'
                            ? Icons.check_circle
                            : Icons.access_time,
                        color: appointment['status'] == 'Done'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text(
                          '$slot - ${appointment['service']} (${appointment['status']})'),
                    );
                  } else {
                    final isSelected = selectedTimeSlot == slot;
                    return ListTile(
                      leading: Icon(Icons.add_circle,
                          color: isSelected ? Colors.amber : Colors.grey),
                      title: Text('$slot - Available'),
                      tileColor: isSelected ? Colors.blue[50] : null,
                      onTap: () {
                        setState(() {
                          selectedTimeSlot = slot;
                        });
                      },
                    );
                  }
                },
              ),

            SizedBox(height: 24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedStylist != null &&
                        selectedTimeSlot != null &&
                        widget.selectedServices.isNotEmpty)
                    ? () {
                        // TODO: Confirm appointment logic here
                      }
                    : null,
                child: Text('Confirm (₱$estimatedTotal)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }

  List<Map<String, dynamic>> generateRandomAppointments() {
    Random random = Random();
    List<Map<String, dynamic>> appointments = [];
    for (int i = 0; i < fullDaySlots.length; i++) {
      if (random.nextBool()) {
        appointments.add({
          'time': fullDaySlots[i],
          'service': random.nextBool() ? 'Haircut' : 'Rebond',
          'status': random.nextBool() ? 'Done' : 'Ongoing',
        });
      }
    }
    return appointments;
  }
}
