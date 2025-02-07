import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:yumfum/classes/shop.dart';

import '../classes/Stock.dart';

class Api {
  static const baseUrl = "http://10.0.2.2:5000/api/";

  static addProduct(Map pdata, File imageFile) async {
    print(pdata);
    var url = Uri.parse("${baseUrl}add_product");

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add the fields (ppreference, pname, etc.)
      request.fields['ppreference'] = pdata['ppreference'];
      request.fields['pname'] = pdata['pname'];
      request.fields['pdescription'] = pdata['pdescription'];
      request.fields['pservingInfo'] = pdata['pservingInfo'];
      request.fields['pnote'] = pdata['pnote'];

      // Add the image as a multipart file
      String? mimeType = lookupMimeType(imageFile.path); // Get the MIME type of the image
      mimeType ??= 'image/jpeg'; // Default to 'image/jpeg' if the MIME type is not found
      var fileStream = http.ByteStream(imageFile.openRead());
      var fileLength = await imageFile.length();
      var multipartFile = http.MultipartFile('pimage', fileStream, fileLength,
          filename: imageFile.uri.pathSegments.last,
          contentType: MediaType.parse(mimeType));

      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var resBody = await response.stream.bytesToString();
        var data = jsonDecode(resBody);
        print(data);
      } else {
        print("Failed to get data");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static packagingAndDelivery(Map pdata) async {
    print(pdata);
    var url = Uri.parse("${baseUrl}packagingAndDelivery");
    try {
      final res = await http.post(url, body: pdata);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to get data");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<Shop>> getShopdata() async {
    List<Shop> shops = [];
    var url = Uri.parse("${baseUrl}shopData");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);

        // ✅ Use 'products' instead of 'shopdetails'
        if (data['products'] != null) {
          shops = List<Shop>.from(
              data['products'].map((item) => Shop.fromJson(item))
          );
        }

        print("Fetched Shops: ${shops.map((shop) => shop.shopName).toList()}");
        return shops;
      } else {
        print("Failed to get data");
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }




  static Future<List<StockStatus>> getStock() async {
    List<StockStatus> stockList = [];
    var url = Uri.parse("${baseUrl}stockStatus");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);

        // Check for the 'products' key instead of 'stockStatus'
        if (data['products'] != null) {
          stockList = List<StockStatus>.from(
            data['products'].map((item) => StockStatus.fromJson(item)),
          );
        }

        print("Fetched Stock Status: ${stockList.map((stock) => stock.name).toList()}");
        return stockList;
      } else {
        print("Failed to get stock data");
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

}
