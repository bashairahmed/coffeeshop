import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(List<Map<String, dynamic>>) updateCart;

  CartScreen({required this.cart, required this.updateCart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeItem(int index) {
    setState(() {
      widget.cart.removeAt(index);
      widget.updateCart(widget.cart);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
        backgroundColor: Colors.brown,
      ),
      body: widget.cart.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                var item = widget.cart[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      'http://10.0.2.2:3000/images/' + (item['image'] ?? ''),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 50);
                      },
                    ),
                    title: Text(item['name']),
                    subtitle: Text("${item['type']} - \$${item['price']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeItem(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
