import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/api.dart';

class PackagingDeliveryPage extends StatefulWidget {
  @override
  _PackagingDeliveryPageState createState() => _PackagingDeliveryPageState();
}

class _PackagingDeliveryPageState extends State<PackagingDeliveryPage> {
  final _formKey = GlobalKey<FormState>();

  final _deliveryTimeController = TextEditingController();
  final _deliveryTimeUnitController = TextEditingController();
  final _deliveryRadiusController = TextEditingController();
  final _deliveryRadiusUnitController = TextEditingController();
  final _freeDeliveryRadiusController = TextEditingController();
  final _freeDeliveryRadiusUnitController = TextEditingController();
  final _orderValue1Controller = TextEditingController();
  final _price1Controller = TextEditingController();
  final _orderValue2Controller = TextEditingController();
  final _price2Controller = TextEditingController();

  Future<void> saveData() async {
    var data = {
      "pTime": _deliveryTimeController.text,  // Use .text to get the value from the controller
      "pTimeUnit": _deliveryTimeUnitController.text,
      "pRadius": _deliveryRadiusController.text,
      "pRadiusUnit": _deliveryRadiusUnitController.text,
      "pFreeDelivery": _freeDeliveryRadiusController.text,
      "pFreeDeliveryUnit": _freeDeliveryRadiusUnitController.text,
      "pOV1": _orderValue1Controller.text,
      "pPrice1": _price1Controller.text,
      "pOV2": _orderValue2Controller.text,
      "pPrice3": _price2Controller.text,
    };

      // Call the API with both the data and the image
      Api.packagingAndDelivery(data);
  }


  Widget _buildRowFields(String label, TextEditingController controller1, String hint1,
      TextEditingController controller2, String hint2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller1,
                decoration: InputDecoration(
                  hintText: hint1,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required field';
                  final number = double.tryParse(value);
                  if (number == null) return 'Enter valid number';
                  if (number < 0) return 'Minimum value is 0';
                  if (number > 100) return 'Maximum value is 100';
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller2,
                decoration: InputDecoration(
                  hintText: hint2,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required field';
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PACKAGING & Delivery'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRowFields(
                  'Delivery Time',
                  _deliveryTimeController,
                  'Enter Value',
                  _deliveryTimeUnitController,
                  'Minutes'
              ),
              _buildRowFields(
                  'Delivery Radius',
                  _deliveryRadiusController,
                  'Enter Value',
                  _deliveryRadiusUnitController,
                  'KM'
              ),
              _buildRowFields(
                  'Free Delivery Radius',
                  _freeDeliveryRadiusController,
                  'Enter Value',
                  _freeDeliveryRadiusUnitController,
                  'KM'
              ),
              Text('Packaging and Delivery Fees:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Order Value(OV) Wise:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildRowFields(
                  '',
                  _orderValue1Controller,
                  'Order Value',
                  _price1Controller,
                  'Enter Price in Rs.'
              ),
              _buildRowFields(
                  '',
                  _orderValue2Controller,
                  'Order Value',
                  _price2Controller,
                  'Enter Price in Rs.'
              ),
              Text('Note:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('1. Minimum Value Allowed: ₹ 0'),
              Text('2. Maximum Value Allowed: ₹ 100'),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  onPressed: saveData,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _deliveryTimeController.dispose();
    _deliveryTimeUnitController.dispose();
    _deliveryRadiusController.dispose();
    _deliveryRadiusUnitController.dispose();
    _freeDeliveryRadiusController.dispose();
    _freeDeliveryRadiusUnitController.dispose();
    _orderValue1Controller.dispose();
    _price1Controller.dispose();
    _orderValue2Controller.dispose();
    _price2Controller.dispose();
    super.dispose();
  }
}