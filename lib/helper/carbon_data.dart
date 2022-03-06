import 'package:http/http.dart' as http;

void main(List<String> args) {
  CarbonData.getCarbonData();
}

class CarbonData {
  static getCarbonData() async {
    Uri url =
        Uri.https("karbon-ayak-izi.herokuapp.com", "/get_carbon_footprint");
    http.Response response = await http.get(url);
    print(response.body);
  }
}
