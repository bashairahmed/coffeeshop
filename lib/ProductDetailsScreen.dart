// ProductDetailsScreen.dart
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final void Function(Map<String, dynamic>) addToCart;

  ProductDetailsScreen({required this.product, required this.addToCart});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              'http://10.0.2.2:3000/images/' + (widget.product['image'] ?? ''),
              width: double.infinity,
              height: 400, 
              fit: BoxFit.cover,
            ),
            Text("${widget.product['name']} - \$${widget.product['price']}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) setState(() => quantity--);
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() => quantity++);
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                widget.addToCart({
                  'name': widget.product['name'],
                  'price': widget.product['price'],
                  'image': widget.product['image'],
                  'quantity': quantity,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تمت الإضافة إلى السلة!")),
                );
              },
              child: Text("طلب الآن"),
            ),
          ],
        ),
      ),
    );
  }
}
