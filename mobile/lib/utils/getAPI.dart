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