import 'package:flutter/material.dart';
import 'package:karbon_ayak_izi/handler/emission_data_handler.dart';
import 'package:karbon_ayak_izi/models/categoric_emission.dart';
import 'package:karbon_ayak_izi/models/product.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChartWidget extends StatelessWidget {
  final List<CategoricEmission> _categoricEmissionData;
  EmissionHandler emissionHandler = EmissionHandler();
  DoughnutChartWidget(this._categoricEmissionData, {Key? key})
      : super(key: key);

  double _getTotalEmission() {
    double total = 0;
    _categoricEmissionData.forEach((element) {
      total += element.emission;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: SfCircularChart(
        legend: Legend(
            isVisible: true, itemPadding: 4, alignment: ChartAlignment.center),
        series: <CircularSeries>[
          // Renders doughnut chart
          DoughnutSeries<CategoricEmission, String>(
              dataSource: _categoricEmissionData,
              explode: true,
              innerRadius: '60%',
              xValueMapper: (CategoricEmission data, _) => data.category,
              yValueMapper: (CategoricEmission data, _) => data.emission,
              dataLabelMapper: (CategoricEmission data, _) =>
                  "%${data.emission * 100 ~/ _getTotalEmission()}",
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
              )),
        ],
      ),
    );
  }
}
