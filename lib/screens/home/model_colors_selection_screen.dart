import 'package:flutter/material.dart';
import 'package:revmo/models/catalog.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/catalog/car_selection_detailed_page.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';

class ModelColorsSelectionsScreen extends StatelessWidget {
  final Catalog catalog;
  const ModelColorsSelectionsScreen(this.catalog);

  // final double _fullScreenHeight = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RevmoAppBar(),
        backgroundColor: RevmoColors.darkBlue,
        body: Container(
          // height: _fullScreenHeight,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.92),
                  itemCount: catalog.length,
                    itemBuilder: (cnxt, itemIndex) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CarSelectionDetailedPage(catalog.fullCarList[itemIndex]),
                        )),
              )
            ],
          ),
        ));
  }
}
