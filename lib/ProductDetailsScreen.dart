import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1; // عدد الطلبات
  double totalPrice = 0; // السعر الكلي

  @override
  void initState() {
    super.initState();
    totalPrice = widget.product['price'].toDouble(); // تعيين السعر الابتدائي
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = widget.product['price'] * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Image.network(
                'http://10.0.2.2:3000/images/' + (widget.product['image'] ?? ''),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${widget.product['type']} - \$${widget.product['price']}",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Description:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.product.containsKey('description') && widget.product['description'] != null
                        ? widget.product['description']
                        : "No description available.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),

                  // 🔥🔥🔥 إضافة العداد والسعر 🔥🔥🔥
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, size: 32),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                              updateTotalPrice();
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$quantity", // عرض العدد الحالي
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 32),
                        onPressed: () {
                          setState(() {
                            quantity++;
                            updateTotalPrice();
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 🔥🔥🔥 عرض السعر الإجمالي 🔥🔥🔥
                  Center(
                    child: Text(
                      "السعر الكلي: \$${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),

                  SizedBox(height: 30),

                  // زر الطلب
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم طلب ${quantity} من ${widget.product['name']} بسعر \$${totalPrice.toStringAsFixed(2)}")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text("طلب الآن"),
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
}
