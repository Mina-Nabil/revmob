import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/catalog.dart';
import 'package:revmo/models/cars/model.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/brand_filter_tile.dart';
import 'package:revmo/shared/widgets/misc/category_filter_tile.dart';
import 'package:revmo/shared/widgets/misc/color_filter_tile.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/page_break.dart';
import 'package:revmo/shared/widgets/misc/secondary_button.dart';
import 'package:revmo/shared/widgets/misc/model_filter_tile.dart';

class RevmoFiltersSheet extends StatefulWidget {
  final Catalog catalog;

  final ValueNotifier<HashSet<Brand>> brandFilters;
  final ValueNotifier<HashSet<ModelColor>> colorFilters;
  final ValueNotifier<HashSet<CarModel>> modelFilters;
  final ValueNotifier<HashSet<Car>> catgFilters;
  final ValueNotifier<double> minPrice;
  final ValueNotifier<double> maxPrice;
  const RevmoFiltersSheet(
      this.catalog, this.brandFilters, this.modelFilters, this.catgFilters, this.colorFilters, this.minPrice, this.maxPrice);

  @override
  _RevmoFiltersSheetState createState() => _RevmoFiltersSheetState();
}

class _RevmoFiltersSheetState extends State<RevmoFiltersSheet> {
  final double _cornerRadius = 12.0;

  notifyFiltersListeners() {
    setState(() {});
  }

  toggleBrand(Brand b) {
    if (widget.brandFilters.value.contains(b)) {
      widget.brandFilters.value.remove(b);
    } else {
      widget.brandFilters.value.add(b);
      widget.modelFilters.value.retainWhere((model) => widget.brandFilters.value.contains(model.brand));
      widget.catgFilters.value.retainWhere((car) => widget.brandFilters.value.contains(car.model.brand));
      widget.colorFilters.value.retainWhere((c) => widget.catalog
          .filterColors(
              brandSet: widget.brandFilters.value, modelSet: widget.modelFilters.value, carSet: widget.catgFilters.value)
          .contains(c));
    }
    notifyFiltersListeners();
  }

  toggleModel(CarModel m) {
    if (widget.modelFilters.value.contains(m)) {
      widget.modelFilters.value.remove(m);
    } else {
      widget.modelFilters.value.add(m);
      widget.catgFilters.value.retainWhere((car) => widget.modelFilters.value.contains(car.model));
      widget.colorFilters.value.retainWhere((c) => widget.catalog
          .filterColors(
              brandSet: widget.brandFilters.value, modelSet: widget.modelFilters.value, carSet: widget.catgFilters.value)
          .contains(c));
    }
    notifyFiltersListeners();
  }

  toggleCategory(Car c) {
    if (widget.catgFilters.value.contains(c)) {
      widget.catgFilters.value.remove(c);
    } else {
      widget.catgFilters.value.add(c);
      widget.colorFilters.value.retainWhere((c) => widget.catalog
          .filterColors(
              brandSet: widget.brandFilters.value, modelSet: widget.modelFilters.value, carSet: widget.catgFilters.value)
          .contains(c));
    }
    notifyFiltersListeners();
  }

  toggleColor(ModelColor mc) {
    if (widget.colorFilters.value.contains(mc)) {
      widget.colorFilters.value.remove(mc);
    } else {
      widget.colorFilters.value.add(mc);
    }
    notifyFiltersListeners();
  }

  applyFilters() {
    Navigator.pop(context, true);
  }

  resetFilters() {
    widget.brandFilters.value.clear();
    widget.modelFilters.value.clear();
    widget.catgFilters.value.clear();
    widget.colorFilters.value.clear();
    widget.minPrice.value = widget.catalog.minCarPrice;
    widget.maxPrice.value = widget.catalog.maxCarPrice;
    notifyFiltersListeners();
  }

  cancel() {
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(_cornerRadius), topRight: Radius.circular(_cornerRadius))),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.filters, 2, color: RevmoColors.darkBlue),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          //brands area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child:
                                RevmoTheme.getSemiBold(AppLocalizations.of(context)!.brands, 1, color: RevmoColors.originalBlue),
                          ),
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 77.5 / 31,
                            children: widget.catalog.brands
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3.5),
                                      child: BrandFilterTile(
                                        onTap: () => toggleBrand(e),
                                        brand: e,
                                        isSelected: widget.brandFilters.value.contains(e),
                                      ),
                                    ))
                                .toList(),
                          ),
                          PageBreak(),
                          //models area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child:
                                RevmoTheme.getSemiBold(AppLocalizations.of(context)!.models, 1, color: RevmoColors.originalBlue),
                          ),

                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 77.5 / 31,
                            children: widget.catalog.models
                                .where((model) =>
                                    widget.brandFilters.value.isEmpty || widget.brandFilters.value.contains(model.brand))
                                .map((model) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3.5),
                                      child: CarModelFilterTile(
                                        onTap: () => toggleModel(model),
                                        model: model,
                                        isSelected: widget.modelFilters.value.contains(model),
                                      ),
                                    ))
                                .toList(),
                          ),
                          //categories area
                          PageBreak(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.categories, 1,
                                color: RevmoColors.originalBlue),
                          ),
                          GridView.count(
                              crossAxisCount: 4,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio: 77.5 / 31,
                              children: widget.catalog.fullListOfCars
                                  .where((car) =>
                                      (widget.brandFilters.value.isEmpty ||
                                          widget.brandFilters.value.contains(car.model.brand)) &&
                                      (widget.modelFilters.value.isEmpty || widget.modelFilters.value.contains(car.model)))
                                  .map((car) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3.5),
                                        child: CategoryFilterTile(
                                          onTap: () => toggleCategory(car),
                                          car: car,
                                          isSelected: widget.catgFilters.value.contains(car),
                                        ),
                                      ))
                                  .toList()),

                          PageBreak(),
                          //colors area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child:
                                RevmoTheme.getSemiBold(AppLocalizations.of(context)!.colors, 1, color: RevmoColors.originalBlue),
                          ),
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 77.5 / 31,
                            children: widget.catalog
                                .filterColors(
                                    brandSet: widget.brandFilters.value,
                                    modelSet: widget.modelFilters.value,
                                    carSet: widget.catgFilters.value)
                                .map((color) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3.5),
                                      child: ColorFilterTile(
                                        onTap: () => toggleColor(color),
                                        color: color,
                                        isSelected: widget.colorFilters.value.contains(color),
                                      ),
                                    ))
                                .toList(),
                          ),

                          //price range area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child:
                                RevmoTheme.getSemiBold(AppLocalizations.of(context)!.price, 1, color: RevmoColors.originalBlue),
                          ),
                          widget.catalog.minCarPrice == 0 && widget.catalog.maxCarPrice == 0
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                        child: RevmoTheme.getBody((widget.minPrice.value / 1000).round().toString() + "k", 1,
                                            color: RevmoColors.darkerBlue)),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          activeTrackColor: RevmoColors.originalBlue,
                                          trackHeight: 0.25,
                                          inactiveTrackColor: RevmoColors.grey,
                                          valueIndicatorColor: RevmoColors.originalBlue,
                                        ),
                                        child: RangeSlider(
                                          min: widget.catalog.minCarPrice,
                                          max: widget.catalog.maxCarPrice,
                                          values: new RangeValues(widget.minPrice.value, widget.maxPrice.value),
                                          onChanged: (values) {
                                            setState(() {
                                              widget.minPrice.value = (values.start / 1000).roundToDouble() * 1000;
                                              widget.maxPrice.value = (values.end / 1000).roundToDouble() * 1000;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                        child: RevmoTheme.getBody((widget.maxPrice.value / 1000).round().toString() + "k", 1,
                                            color: RevmoColors.darkerBlue)),
                                  ],
                                ),
                          MainButton(
                            text: AppLocalizations.of(context)!.apply,
                            callBack: applyFilters,
                          ),
                          SecondaryButton(
                            text: AppLocalizations.of(context)!.reset,
                            callBack: resetFilters,
                            textColor: RevmoColors.originalBlue,
                          ),
                          SecondaryButton(
                            text: AppLocalizations.of(context)!.cancel,
                            callBack: cancel,
                            textColor: RevmoColors.originalBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}
