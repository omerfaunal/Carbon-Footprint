import 'dart:convert';

import 'package:karbon_ayak_izi/handler/emission_data_handler.dart';
import 'package:karbon_ayak_izi/models/product.dart';
import 'package:http/http.dart' as http;

class ImageHandler {
  static sendImageAndGetData(String uri) async {
    List<dynamic> values = [{}];
    Uri url = Uri.https(
        "karbon-ayak-izi.herokuapp.com", "/get_carbon_footprint/${uri}");
    print(url);
    http.Response response = await http.get(url);
    print("rp");
    values = json.decode(response.body);
    values.forEach((element) {
      print(element["category"]);
      EmissionHandler.addTask(Product(
          category: element["category"],
          emission: element["emission"],
          date: element["date"]));
    });
    await EmissionHandler.getData();
  }
}
