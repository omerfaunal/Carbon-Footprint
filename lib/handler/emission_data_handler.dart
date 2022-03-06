import 'package:karbon_ayak_izi/data/dummy_data.dart';
import 'package:get/get.dart';
import 'package:karbon_ayak_izi/database/product_database.dart';
import 'package:karbon_ayak_izi/models/categoric_emission.dart';
import 'package:karbon_ayak_izi/models/monthly_emission.dart';
import 'package:karbon_ayak_izi/models/product.dart';

class EmissionHandler extends GetxController {
  static List<Product> emissionData = <Product>[].obs;
  static double totalEmission = 0;
  static List<MonthlyEmission> monthlyEmission = [];
  static List<CategoricEmission> categoricEmission = [];

  @override
  static Future<void> getData() async {
    ProductDatabase.deleteAll();
    DUMMY_DATA.forEach((element) {
      addTask(element);
    });
    await getTasks();
    getTotalEmission();
    getChartEmissionData();
    getPieEmissionData();
  }

  static Future<void> getTasks() async {
    List<Map<String, dynamic>> products = await ProductDatabase.query();
    print("mapped");
    emissionData
        .assignAll(products.map((e) => new Product.fromJson(e)).toList());
  }

  static Future<int> addTask(Product product) async {
    print("Added");
    return await ProductDatabase.insert(product);
  }

  static void deleteTask(Product product) async {
    await ProductDatabase.delete(product);
    getTasks();
  }

  static getTotalEmission() {
    emissionData.forEach((element) {
      totalEmission += element.emission!;
    });
  }

  static getChartEmissionData() {
    bool _isIncreased = false;
    for (int i = 0; i < emissionData.length; i++) {
      _isIncreased = false;
      for (int j = 0; j < monthlyEmission.length; j++) {
        if (monthlyEmission[j].month == emissionData[i].month) {
          monthlyEmission[j].increaseEmission(emissionData[i].emission!);
          _isIncreased = true;
        }
      }
      if (!_isIncreased) {
        monthlyEmission.add(
          MonthlyEmission(
            month: emissionData[i].month!,
            emission: emissionData[i].emission!,
          ),
        );
      }
    }
  }

  static getPieEmissionData() {
    bool _isIncreased = false;
    for (int i = 0; i < emissionData.length; i++) {
      _isIncreased = false;
      for (int j = 0; j < categoricEmission.length; j++) {
        if (categoricEmission[j].category == emissionData[i].category) {
          categoricEmission[j].increaseEmission(emissionData[i].emission!);
          _isIncreased = true;
        }
      }
      if (!_isIncreased) {
        categoricEmission.add(
          CategoricEmission(
            category: emissionData[i].category!,
            emission: emissionData[i].emission!,
          ),
        );
      }
    }
  }
}
