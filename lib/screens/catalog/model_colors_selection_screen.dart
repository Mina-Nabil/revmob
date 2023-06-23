import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/catalog.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/providers/Seller/catalog_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/car_selection_detailed_page.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModelColorsSelectionWidget extends InheritedWidget {
  final Catalog selectedCars;
  ModelColorsSelectionWidget({required this.selectedCars, required child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant ModelColorsSelectionWidget oldWidget) {
    return selectedCars != oldWidget.selectedCars;
  }

  static ModelColorsSelectionWidget of(BuildContext context) {
    final ModelColorsSelectionWidget? result = context.dependOnInheritedWidgetOfExactType<ModelColorsSelectionWidget>();
    assert(result != null, 'No ModelColorsSelectionWidget widget found in context');
    return result!;
  }

  toggleColor(Car car, ModelColor color) {
    print(selectedCars);
    if (selectedCars.hasCarColor(car, color)) {
      selectedCars.removeCarColor(car, color);
    } else {
      selectedCars.addColorToCar(car, color);
    }
  }
}

class ModelColorsSelectionsScreen extends StatefulWidget {
  final Catalog catalog;
  const ModelColorsSelectionsScreen(this.catalog);

  @override
  State<ModelColorsSelectionsScreen> createState() => _ModelColorsSelectionsScreenState();
}

class _ModelColorsSelectionsScreenState extends State<ModelColorsSelectionsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RevmoAppBar(
          title: AppLocalizations.of(context)!.pickColors,
        ),
        backgroundColor: RevmoColors.darkBlue,
        body: ModelColorsSelectionWidget(
          selectedCars: widget.catalog,
          child: Stack(
            children: [
              Container(
                // height: _fullScreenHeight,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                          controller: PageController(viewportFraction: 0.95),
                          itemCount: widget.catalog.length,
                          itemBuilder: (cnxt, itemIndex) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: CarSelectionDetailedPage(widget.catalog.fullCarList[itemIndex],
                                    selectedColors: widget.catalog.getCarColors(widget.catalog.fullCarList[itemIndex])),
                              )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 23.0),
                      child: MainButton(
                        text: AppLocalizations.of(context)!.addCars,
                        width: double.infinity,
                        callBack: (!isLoading) ? () => submitAddCars(context) : null,
                      ),
                    )
                  ],
                ),
              ),
              if (isLoading)
                Center(
                  child: RevmoTheme.getLoadingContainer(context),
                )
            ],
          ),
        ));
  }

  bool canAdvance() {
    return widget.catalog.canSubmitColors();
  }

  submitAddCars(BuildContext context) async {
    if (canAdvance()) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<CatalogProvider>(context, listen: false).addCarsToCatalog(widget.catalog);
      Navigator.popUntil(context, (route) => route.isFirst);
      setState(() {
        isLoading = false;
      });
    } else {
      RevmoTheme.showRevmoSnackbar(context, AppLocalizations.of(context)!.cantAddCarsMsg);
    }
  }
}
