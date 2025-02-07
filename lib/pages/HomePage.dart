import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:yumfum/pages/Packaging&Delivery.dart';
import 'package:yumfum/pages/VanilaCake.dart';
import 'package:yumfum/pages/AddProduct.dart';
import 'package:yumfum/classes/shop.dart';
import 'package:yumfum/utils/api.dart';  // Import the API class

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String shopName = 'Loading...';
  String fssaiLicenseNumber = 'Loading...';
  File? _image;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  Future<void> fetchShopData() async {
    List<Shop> shops = await Api.getShopdata();

    if (shops.isNotEmpty) {
      setState(() {
        shopName = shops[0].shopName ?? 'No Shop Name';
        fssaiLicenseNumber = shops[0].fssaiId ?? 'No License';
        isLoading = false;
      });
    } else {
      setState(() {
        shopName = 'No Shop Data';
        fssaiLicenseNumber = 'No License Available';
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          elevation: 3,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(color: Colors.red, fontSize: 16)),
            Icon(icon, color: Colors.red),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Shop'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop Name: $shopName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'FSSAI License Number: $fssaiLicenseNumber',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
              ],
            ),

            Text(
              'Add Shop Display Photo:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _pickImage,
              child: Text('Add Image'),
            ),

            if (_image != null)
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Image.file(
                  _image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            _buildActionButton(
              text: 'Offers & Discounts',
              icon: Icons.local_offer,
              onPressed: () {},
            ),

            _buildActionButton(
              text: 'Other Settings',
              icon: Icons.settings,
              onPressed: () {},
            ),

            _buildActionButton(
              text: 'Packaging and Delivery',
              icon: Icons.local_shipping,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PackagingDeliveryPage()),
                );
              },
            ),

            _buildActionButton(
              text: 'Products',
              icon: Icons.shopping_cart,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
            ),

            _buildActionButton(
              text: 'Promotions',
              icon: Icons.campaign,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VanillaCakePage()),
                );
              },
            ),

            SizedBox(height: 16),
            Text(
              'Note: Shop will not be visible to customers if you have no products added!',
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
            Text(
              'Add products at menu price to avoid items being delisted in the future!',
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
