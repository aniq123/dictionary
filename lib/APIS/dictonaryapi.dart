import 'dart:convert';

import 'package:freedictionaryapi/models/freedictionary.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class dictonaryapi extends GetxController {
  var items = <Freedictionarymodel>[].obs;
  RxBool isloading = false.obs;

  Future<void> featchapi(String query) async {
    isloading(true);
    final response = await http
        .get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/fart'));
    if (response.statusCode == 200) {
      // Parse JSON data directly
      final List<dynamic> jsondata = json.decode(response.body);
      // Map the parsed data to Freedictionarymodel objects
      items.value =
          jsondata.map((json) => Freedictionarymodel.fromJson(json)).toList();
    } else {
      print('Not Found, Please search again');
    }

    isloading(false);
  }

  @override
  void onInit() {
    super.onInit();
    //automitically inizilize the data when function is called
    // featchapi();
  }
}
