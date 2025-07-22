import 'package:flutter/material.dart';
import 'package:hairhouse/pages/notifications.dart';
import '../package/profilebuttons/purchased.dart';

// 🌐 Global purchased products list
List<Map<String, dynamic>> purchasedProducts = [];

// 🌐 Global notifications list
List<String> notifications = [];

// ➕ Function to add purchased items
void addPurchasedItems(List<Map<String, dynamic>> items) {
  purchasedProducts.addAll(items);
}

// ➕ Function to add notifications
void addNotification(String message) {
  notifications.insert(0, message); // latest on top
}

class PurchasePage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;

  PurchasePage({this.selectedItems = const []});

  @override
  Widget build(BuildContext context) {
    int total =
        selectedItems.fold(0, (sum, item) => sum + (item['price'] as int));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.amberAccent),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        item['image'],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.amberAccent, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text('₱${item['price']}',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Divider(color: Colors.amberAccent),
            Text(
              'Total: ₱$total',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.amberAccent),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amberAccent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(
                      'Full Name', Colors.amberAccent, Colors.white),
                  SizedBox(height: 12),
                  _buildTextField('Address', Colors.amberAccent, Colors.white),
                  SizedBox(height: 12),
                  _buildTextField(
                      'Contact Number', Colors.amberAccent, Colors.white,
                      keyboardType: TextInputType.phone),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Payment Option',
                      labelStyle: TextStyle(color: Colors.amberAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amberAccent, width: 2),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    items: [
                      DropdownMenuItem(
                          value: 'COD',
                          child: Text('Cash on Delivery',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 'Pickup',
                          child: Text('Pick Up',
                              style: TextStyle(color: Colors.white))),
                    ],
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.amberAccent, width: 2),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.black,
                      ),
                      child: Text('Place Order',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        // ✅ Save purchases
                        addPurchasedItems(selectedItems);

                        // ✅ Add notification
                        addNotification(
                            '🛒 Purchase confirmed. Total ₱$total at ${DateTime.now().toString().substring(0, 16)}');

                        // ✅ Show confirmation dialog only
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.black,
                            title: Text('Success',
                                style: TextStyle(color: Colors.amberAccent)),
                            content: Text(
                              'Your order has been placed successfully.',
                              style: TextStyle(color: Colors.white),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                },
                                child: Text('OK',
                                    style:
                                        TextStyle(color: Colors.amberAccent)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, Color labelColor, Color textColor,
      {TextInputType? keyboardType}) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: labelColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: labelColor, width: 2),
        ),
      ),
    );
  }
}
