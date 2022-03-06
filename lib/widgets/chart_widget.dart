// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:karbon_ayak_izi/models/monthly_emission.dart';
import 'package:karbon_ayak_izi/models/product.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatelessWidget {
  final List<MonthlyEmission> _monthlyEmissionData;
  const Chart(this._monthlyEmissionData, {Key? key}) : super(key: key);

  double _getMaximumValue() {
    double max = 0;
    _monthlyEmissionData.forEach((element) {
      max < element.emission ? max = element.emission : null;
    });
    return max;
  }

  double _getMinimumValue() {
    double min = 99999;
    _monthlyEmissionData.forEach((element) {
      min > element.emission ? min = element.emission : null;
    });
    return min;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          /*    title: ChartTitle(
              text: 'Carbon Emission',
              textStyle: TextStyle(color: Colors.white, fontSize: 20)),*/
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <SplineSeries>[
            SplineSeries<MonthlyEmission, int>(
                name: 'Emission',
                dataSource: _monthlyEmissionData,
                xValueMapper: (MonthlyEmission product, _) =>
                    product.month.month,
                yValueMapper: (MonthlyEmission product, _) => product.emission,
                dataLabelSettings: DataLabelSettings(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w100, color: Colors.white),
                    isVisible: true,
                    showCumulativeValues: true),
                color: Colors.white,
                width: 4,
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 0.9),
          ],
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(
            axisLine: AxisLine(width: 0),
            labelStyle: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
            minimum: _getMinimumValue() - 30,
            maximum: _getMaximumValue() + 20,
            associatedAxisName: null,
            majorGridLines: MajorGridLines(
                width: 1,
                color: Colors.white38,
                dashArray: const <double>[5, 5]),
          ),
        ));
  }
}
