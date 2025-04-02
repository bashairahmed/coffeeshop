

// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CartScreen.dart';
import 'ProductDetailsScreen.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoffeeListScreen(),
    );
  }
}

class CoffeeListScreen extends StatefulWidget {
  const CoffeeListScreen({super.key});

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
        backgroundColor: Colors.brown,
        title: const Text("Coffee Menu" , style: TextStyle(
        color:  Colors.white,
        ),),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Colors.white,
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
                    child: Text('${cart.length}',
                        style: const TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: coffeeList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    elevation: 4,
                    child: Column(
                      children: [
                        Image.network('http://10.0.2.2:3000/images/' + (coffee['image'] ?? ''),
                        width: double.infinity,
                            height: 150, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(coffee['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("${coffee['type']} - \$${coffee['price']}",
                                  style: const TextStyle(color: Colors.grey)),
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