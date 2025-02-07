import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:yumfum/utils/api.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool inStockStatus = false;
  bool uploadImages = false;
  final _formKey = GlobalKey<FormState>();
  String? selectedFoodType;
  File? productImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController servingInfoController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        productImage = File(image.path);
      });
    }

  }
  Future<void> saveData() async {
    // Ensure you have a valid image before calling the API
    if (productImage != null) {
      var data = {
        "ppreference": selectedFoodType,  // ✅ Corrected (No `.text` for a String)
        "pname": productNameController.text,
        "pdescription": descriptionController.text,
        "pservingInfo": servingInfoController.text,
        "pnote": noteController.text,
      };

      // Call the API with both the data and the image
      Api.addProduct(data, productImage!);
    } else {
      print("Please select an image to upload.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD PRODUCT'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('In Stock Status:*'),
                      Switch(
                        value: inStockStatus,
                        onChanged: (value) => setState(() => inStockStatus = value),
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Upload Product Images:'),
                          Text(
                            'Customers can add up to 2 product \nimages for customisation!',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Switch(
                        value: uploadImages,
                        onChanged: (value) => setState(() => uploadImages = value),
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Food Preference:*'),
                  DropdownButtonFormField<String>(
                    value: selectedFoodType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select food preference',
                    ),
                    items: ['Veg', 'Non-Veg', 'Vegan'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedFoodType = value),
                  ),
                  SizedBox(height: 16),
                  Text('Product Name:*'),
                  TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter product name',
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  Text('Description:*'),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter product description',
                    ),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  Text('Serving Information:'),
                  TextFormField(
                    controller: servingInfoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter serving details',
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),
                  Text('Note:'),
                  TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter additional notes',
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),
                  Text('Flavour, size and price chart:'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {},
                    child: Text('Edit List'),
                  ),
                  SizedBox(height: 16),
                  Text('Customization:'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {},
                    child: Text('Edit List'),
                  ),
                  SizedBox(height: 16),
                  Text('Add Product Image (Max 1):*'),
                  SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                    onPressed: pickImage,
                    child: Text('Add Image', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                    onPressed: () {},
                    child: Text('Copy', style: TextStyle(color: Colors.red)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      saveData();
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}