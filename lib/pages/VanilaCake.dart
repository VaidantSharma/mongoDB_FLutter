import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yumfum/utils/api.dart'; // Import the Api class where getStock is defined
import 'package:yumfum/classes/Stock.dart'; // Import your StockStatus class

class VanillaCakePage extends StatefulWidget {
  @override
  _VanillaCakePageState createState() => _VanillaCakePageState();
}

class _VanillaCakePageState extends State<VanillaCakePage> {
  List<StockStatus> inStockItems = [];
  List<StockStatus> outOfStockItems = [];

  @override
  void initState() {
    super.initState();
    getStockData();
  }

  // Use the getStock method from Api class
  Future<void> getStockData() async {
    try {
      List<StockStatus> stockData = await Api.getStock(); // Call the Api.getStock method

      setState(() {
        // Split items into inStock and outOfStock based on the status
        inStockItems = stockData.where((item) => item.status == true).toList();
        outOfStockItems = stockData.where((item) => item.status == false).toList();
      });

      print("Fetched Stock Status: ${stockData.map((stock) => stock.name).toList()}");
    } catch (e) {
      print('Error fetching stock data: $e');
    }
  }

  Widget _buildStockItem(StockStatus item, bool showMenu) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(Icons.remove, color: Colors.grey),
        title: Text(
          item.name ?? 'Unknown Item',
          style: TextStyle(color: Colors.red),
        ),
        subtitle: Text('Added On: ${item.date ?? '02/07/2024'}'),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            // Handle menu options
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('VANILLA CAKE'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('In Stock:', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: inStockItems.length,
              itemBuilder: (context, index) =>
                  _buildStockItem(inStockItems[index], true),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Out of Stock:', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: outOfStockItems.length,
              itemBuilder: (context, index) =>
                  _buildStockItem(outOfStockItems[index], false),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {
                          // Handle Add On Items
                        },
                        child: Text('Add On Items'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {
                          // Handle Options
                        },
                        child: Text('Options'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Handle Add Product
                    },
                    child: Text('Add Product'),
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
