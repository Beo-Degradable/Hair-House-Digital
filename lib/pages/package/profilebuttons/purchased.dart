import 'package:flutter/material.dart';
import '../../products/purchase.dart'; // Import to access purchasedProducts

class PurchasedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('My Purchases'),
        backgroundColor: Colors.amber[700],
      ),
      body: purchasedProducts.isEmpty
          ? Center(
              child: Text(
                'No purchases yet.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: purchasedProducts.length,
              itemBuilder: (context, index) {
                final product = purchasedProducts[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[700]!),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      product['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      product['name'],
                      style: TextStyle(color: Colors.amber[200], fontSize: 14),
                    ),
                    trailing: Text(
                      '₱${product['price']}',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
