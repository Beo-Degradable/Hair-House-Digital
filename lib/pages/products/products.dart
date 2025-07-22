import 'package:flutter/material.dart';
import 'cart.dart';
import 'purchase.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final String searchQuery;
  final VoidCallback onCartUpdated;

  ProductsPage({
    required this.cart,
    required this.onCartUpdated,
    this.searchQuery = '',
  });

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Shampoo',
      'price': 150,
      'image': 'images/shampoo.jpg',
    },
    {
      'name': 'Conditioner',
      'price': 200,
      'image': 'images/conditioner.webp',
    },
    {
      'name': 'Hair Wax',
      'price': 250,
      'image': 'images/wax.webp',
    },
    {
      'name': 'Hair Serum',
      'price': 300,
      'image': 'images/hairserum.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      return product['name'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];

        return SizedBox(
          height: 250, // Predetermined card height
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amberAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    height: 100, // Fixed image height
                    width: double.infinity,
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    '₱${product['price']}',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 6.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: Colors.amberAccent, width: 2),
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PurchasePage(
                                  selectedItems: [product],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Buy',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: Colors.amberAccent, width: 2),
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            cart.add(product);
                            onCartUpdated();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  '${product['name']} added to cart',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            'Cart',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 10),
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
  }
}
