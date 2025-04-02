import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(List<Map<String, dynamic>>) updateCart;

  CartScreen({required this.cart, required this.updateCart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // حساب الإجمالي للسلة
  double get totalAmount {
    double total = 0.0;
    for (var item in widget.cart) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  // دالة للدفع (مثلًا سيتم إعادة تعيين السلة هنا بعد الدفع)
  void _checkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("الدفع"),
        content: Text("تم الدفع بنجاح!"),
        actions: [
          TextButton(
            onPressed: () {
              widget.updateCart([]);  // تفريغ السلة بعد الدفع
              Navigator.of(context).pop();
            },
            child: Text("موافق"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("سلة المشتريات")),
      body: widget.cart.isEmpty
          ? Center(child: Text("السلة فارغة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      var item = widget.cart[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          leading: Image.network(
                            'http://10.0.2.2:3000/images/' + (item['image'] ?? ''),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text("السعر: \$${item['price']} × ${item['quantity']}",
                              style: TextStyle(color: Colors.grey)),
                          trailing: Text("الإجمالي: \$${item['price'] * item['quantity']}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("الإجمالي:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("\$${totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _checkout,
                        child: Text("إتمام الدفع", style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
