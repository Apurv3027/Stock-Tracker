import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_tracker/add_product.dart';
import 'package:stock_tracker/database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _dbHelper.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stock Tracker",
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.download,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: _products.isEmpty
          ? Center(
              child: Text(
                "No data added yet.",
              ),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    // leading: Text(
                    //   product['id'].toString(),
                    // ),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tag,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          product['id'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Serial No: ${product['serial'] ?? ''}",
                        ),
                        Text(
                          "Name: ${product['name'] ?? ''}",
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dimension: ${product['length']} x ${product['height']} x ${product['width']} cm",
                        ),
                        Text(
                          "Size: ${product['size']} | Origin: ${product['origin']}",
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        // await _dbHelper.deleteProduct(
                        //   product['id'],
                        // );
                        // _loadProducts();
                      },
                    ),
                  ),
                );
              },
            ).paddingAll(8),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final success = await Get.to(
            AddProduct(),
          );

          if (success == true) {
            _loadProducts();
          }
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
