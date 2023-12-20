import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:rest_api/model/model.dart';

class Repository {
  //api yang digunakan
  String final_baseUrl = 'https://reqres.in/api/unknown';

  Future getData() async {
    try {
      http.Response response = await http.get(Uri.parse(final_baseUrl));
      if (response.statusCode == HttpStatus.ok) {
        if (kDebugMode) {}
        final jsonResponse = json.decode(response.body);
        final datablog = jsonResponse['data'];
        List blog = datablog.map((i) => Blog.fromJson(i)).toList();
        return blog;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}