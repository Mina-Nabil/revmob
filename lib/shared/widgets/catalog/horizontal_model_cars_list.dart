import 'package:flutter/material.dart';
import 'package:revmo/models/cars/model.dart';
import 'package:revmo/screens/catalog/brand_models_screen.dart';
import 'package:revmo/shared/widgets/catalog/category_card.dart';

class HorizontalModelCarsList extends StatefulWidget {
  final CarModel? model;
  final bool isLoading;
  bool get showCars => !isLoading && model != null;
  HorizontalModelCarsList(this.model) : isLoading = false;
  HorizontalModelCarsList.placeholder()
      : this.model = null,
        isLoading = true;

  @override
  _HorizontalModelCarsListState createState() => _HorizontalModelCarsListState();
}

class _HorizontalModelCarsListState extends State<HorizontalModelCarsList> {
  final double _carHeight = 430;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _carHeight,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.95),
        itemCount: widget.showCars ? widget.model!.cars.length : 2,
        itemBuilder: (cnxt, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: widget.showCars
              ? CategoryCard(widget.model!.cars[index], CarsSelectionWidget.of(context).isOwned(widget.model!.cars[index]))
              : CategoryCard.placeholder(),
        ),
      ),
    );
  }
}
