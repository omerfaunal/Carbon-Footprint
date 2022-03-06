// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:karbon_ayak_izi/models/categoric_emission.dart';
import 'package:karbon_ayak_izi/models/product.dart';
import 'package:karbon_ayak_izi/widgets/doughnut_chart_widget.dart';

class CategoryWidget extends StatelessWidget {
  final List<CategoricEmission> _categoricEmissionData;
  CategoryWidget(this._categoricEmissionData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10),
        height: 230,
        width: screenWidth * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kategorilere göre ayak izi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text("Kategorilere göre oluşturduğun karbon ayak izin"),
            DoughnutChartWidget(_categoricEmissionData),
          ],
        ),
      ),
    );
  }
}
