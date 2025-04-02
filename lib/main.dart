import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CartScreen.dart';
import 'ProductDetailsScreen.dart';


void main() {
  runApp(CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoffeeListScreen(),
    );
  }
}

class CoffeeListScreen extends StatefulWidget {
  @override
  _CoffeeListScreenState createState() => _CoffeeListScreenState();
}

class _CoffeeListScreenState extends State<CoffeeListScreen> {
  List<dynamic> coffeeList = [];
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    fetchCoffeeData();
  }

  Future<void> fetchCoffeeData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/products'));

    if (response.statusCode == 200) {
      setState(() {
        coffeeList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load coffee data');
    }
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Coffee Menu", style: TextStyle(color: Colors.white)),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_bag),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(cart: cart, updateCart: (updatedCart) {
                          setState(() {
                            cart = updatedCart;
                          });
                        }),
                      ),
                    );
                  },
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cart.length}',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.brown,
      ),
      body: coffeeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: coffeeList.length,
              itemBuilder: (context, index) {
                var coffee = coffeeList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: coffee,
                          addToCart: addToCart,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            'http://10.0.2.2:3000/images/' + (coffee['image'] ?? ''),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                coffee['name'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${coffee['type']} - \$${coffee['price']}",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
