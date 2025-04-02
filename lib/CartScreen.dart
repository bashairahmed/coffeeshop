// CartScreen.dart
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(List<Map<String, dynamic>>) updateCart;

  CartScreen({required this.cart, required this.updateCart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("سلة المشتريات")),
      body: widget.cart.isEmpty
          ? Center(child: Text("السلة فارغة"))
          : ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                var item = widget.cart[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("السعر: \$${item['price']} × ${item['quantity']}"),
                  trailing: Text("الإجمالي: \$${item['price'] * item['quantity']}"),
                );
              },
            ),
    );
  }
}
