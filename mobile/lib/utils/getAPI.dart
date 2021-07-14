import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String urlBase = 'https://cop4331group2.herokuapp.com/api';

class API {
  static Future<String> getJson(String dir, Map data) async {
    String ret = "";
    try {
      http.Response res = await http.post(
        Uri.parse(urlBase + dir),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(data),
      );
      if (res.statusCode >= 200 && res.statusCode <= 202) {
        ret = res.body;
      } else {
        throw Exception('Status Code ' + res.statusCode.toString());
      }
    } catch (e) {
      print(e.toString());
    }
    return ret;
  }
}

// class CardsData {
//   static Future<String> getJson(String url, String outgoing) async {
//     String ret = "";
//     try {
//       http.Response response = await http.post(url,
//           body: utf8.encode(outgoing),
//           headers: {
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//           },
//           encoding: Encoding.getByName("utf-8"));
//       ret = response.body;
//     } catch (e) {
//       print(e.toString());
//     }
//     return ret;
//   }
// }
