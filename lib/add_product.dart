import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_tracker/database/database_helper.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final List<String> sizeOptions = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  String? selectedSize;

  final TextEditingController serialController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController originController = TextEditingController();

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newProduct = {
          'serial': serialController.text,
          'name': nameController.text,
          'length': double.parse(lengthController.text),
          'height': double.parse(heightController.text),
          'width': double.parse(widthController.text),
          'size': sizeController.text,
          'origin': originController.text,
          'createdAt': DateTime.now().toString(),
        };

        print("newProduct: $newProduct");

        final dbHelper = DatabaseHelper.instance;
        final id = await dbHelper.insertProduct(newProduct);

        if (id > 0) {
          Get.back(
            result: true,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save product',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print(e.toString());
        Get.snackbar(
          'Error',
          'Failed to save product: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    serialController.dispose();
    nameController.dispose();
    lengthController.dispose();
    heightController.dispose();
    widthController.dispose();
    sizeController.dispose();
    originController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Product',
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: serialController,
                decoration: InputDecoration(
                  labelText: "Serial Number",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(
                    Icons.confirmation_number,
                  ),
                  hintText: "Product-12345",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Serial number is required';
                  }
                  if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(value)) {
                    return 'Only alphanumeric characters and hyphens allowed';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.shopping_bag,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product name is required';
                  }
                  if (value.length < 3) {
                    return 'Name too short (min 3 charcters)';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: lengthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Length",
                        border: OutlineInputBorder(),
                        suffixText: "cm",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter length';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Must be positive';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Height",
                        border: OutlineInputBorder(),
                        suffixText: "cm",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter height';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Must be positive';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: widthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Width",
                        border: OutlineInputBorder(),
                        suffixText: "cm",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter width';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Must be positive';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              // TextFormField(
              //   controller: sizeController,
              //   decoration: const InputDecoration(
              //     labelText: "Size",
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(
              //       Icons.straighten,
              //     ),
              //     hintText: "e.g., S, M, L or specific dimensions",
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Size is required';
              //     }
              //     return null;
              //   },
              // ),
              DropdownButtonFormField<String>(
                value: selectedSize,
                decoration: const InputDecoration(
                  labelText: "Size",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.straighten,
                  ),
                  hintText: "Select size",
                ),
                items: sizeOptions.map((String size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a size';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSize = newValue;
                    sizeController.text = newValue ?? '';
                  });
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: originController,
                decoration: const InputDecoration(
                  labelText: "Country of Origin",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.flag,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Origin is required';
                  }
                  if (value.length < 2) {
                    return 'Enter valid country name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Save Product
                    _saveProduct();
                  },
                  child: const Text(
                    "SAVE PRODUCT",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).paddingAll(16),
      ),
    );
  }
}
