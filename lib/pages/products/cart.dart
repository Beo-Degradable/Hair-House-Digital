import 'package:flutter/material.dart';
import 'purchase.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Set<int> selectedIndexes = {};
  bool selectionMode = false;

  double get totalPrice {
    double total = 0;
    for (int index in selectedIndexes) {
      total += widget.cart[index]['price'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        actions: selectionMode
            ? [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectionMode = false;
                      selectedIndexes.clear();
                    });
                  },
                )
              ]
            : null,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }

          Widget cartList;

          if (orientation == Orientation.portrait) {
            cartList = ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(item, index);
              },
            );
          } else {
            cartList = GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(item, index);
              },
            );
          }

          return Column(
            children: [
              Expanded(child: cartList),
              if (selectionMode && selectedIndexes.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total: ₱${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2), // gold border
                          backgroundColor:
                              Color(0xFF1C1C1C), // black background
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          final selectedItems = selectedIndexes
                              .map((index) => cartItems[index])
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PurchasePage(
                                selectedItems: selectedItems,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Buy Selected Items',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // Updated widget builder with long press selection logic
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    final isSelected = selectedIndexes.contains(index);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          selectionMode = true;
          selectedIndexes.add(index);
        });
      },
      onTap: () {
        if (selectionMode) {
          setState(() {
            if (isSelected) {
              selectedIndexes.remove(index);
              if (selectedIndexes.isEmpty) {
                selectionMode = false;
              }
            } else {
              selectedIndexes.add(index);
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.3) : Colors.black87,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'],
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                item['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '₱${item['price']}',
                style: TextStyle(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Color(0xFFFFD700), width: 2), // gold border
                  backgroundColor: Color(0xFF1C1C1C), // black background
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PurchasePage(
                        selectedItems: [item],
                      ),
                    ),
                  );
                },
                child: Text(
                  'Buy Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
