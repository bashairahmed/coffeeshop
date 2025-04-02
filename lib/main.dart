import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Coffee Menu")),
      body: coffeeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: coffeeList.length,
              itemBuilder: (context, index) {
                var coffee = coffeeList[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      'http://10.0.2.2:3000/images/' + coffee['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image,
                            size: 50); // عرض أيقونة عند حدوث خطأ
                      },
                    ),
                    title: Text(coffee['name']),
                    subtitle: Text("${coffee['type']} - \$${coffee['price']}"),
                  ),
                );
              },
            ),
    );
  }
}
