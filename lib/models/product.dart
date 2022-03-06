import 'package:intl/intl.dart';

class Product {
  int? id;
  String? category;
  String? date;
  DateTime? month;
  double? emission;

  Product(
      {required this.category, required this.emission, required this.date}) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    month = inputFormat.parse(date!);
  }

  Product.fromJson(Map<String, dynamic> json) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    id = json['id'];
    category = json["category"].toString();
    date = json["date"];
    emission = json["emission"];
    getMonth();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['date'] = this.date;
    data['emission'] = this.emission;

    return data;
  }

  getMonth() {
    var inputFormat = DateFormat('dd/MM/yyyy');
    month = inputFormat.parse(date!);
  }
}
