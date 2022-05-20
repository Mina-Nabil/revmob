import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/catalog.dart';
import 'package:revmo/providers/catalog_provider.dart';
import 'package:revmo/providers/models_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/screens/catalog/model_colors_selection_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/horizontal_model_cars_list.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/no_cars_found.dart';

class CarsSelectionWidget extends InheritedWidget {
  final Catalog selectedCars;
  final Catalog ownedCars;
  CarsSelectionWidget(this.selectedCars, this.ownedCars, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(covariant CarsSelectionWidget oldWidget) {
    return selectedCars != oldWidget.selectedCars;
  }

  static CarsSelectionWidget of(BuildContext context) {
    final CarsSelectionWidget? result = context.dependOnInheritedWidgetOfExactType<CarsSelectionWidget>();
    assert(result != null, 'No CarSelection widget found in context');
    return result!;
  }

  bool hasCar(Car c) {
    return selectedCars.hasCar(c);
  }

  bool isOwned(Car c) {
    return ownedCars.hasCar(c);
  }

  toggleCar(Car c) {
    if (selectedCars.hasCar(c))
      selectedCars.removeCar(c);
    else {
      if (isOwned(c))
        selectedCars.addCarWithColors(c, ownedCars.getCarColors(c));
      else
        selectedCars.addCar(c);
    }
    print(selectedCars.toString());
  }
}

class BrandModelsScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/model/brands";
  final Brand _brand;
  BrandModelsScreen({required Brand brand}) : this._brand = brand;

  @override
  _BrandModelsScreenState createState() => _BrandModelsScreenState();
}

class _BrandModelsScreenState extends State<BrandModelsScreen> {
  late Catalog selectedCars;
  late Catalog ownedCars;
  bool isLoading = true;
  bool canAdvance = false;
  @override
  void initState() {
    isLoading = true;
    selectedCars = new Catalog();
    Future.delayed(Duration.zero).then((_) async {
      if (this.mounted) {
        setState(() {
          isLoading = true;
          canAdvance = false;
        });
        await Provider.of<ModelsProvider>(context, listen: false).loadModels(widget._brand.id, true);
        await Provider.of<CatalogProvider>(context, listen: false).loadCatalog();
        setState(() {
          isLoading = false;
          canAdvance = false;
        });
      }
    });

    super.initState();
  }

  advanceForm() {
    if (selectedCars.length > 0) {
      Navigator.of(context)
          .push(PageTransition(child: ModelColorsSelectionsScreen(selectedCars), type: PageTransitionType.rightToLeft));
    } else {
      RevmoTheme.showRevmoSnackbar(context, AppLocalizations.of(context)!.emptyCarsList);
    }
  }

  goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RevmoAppBar(title: AppLocalizations.of(context)!.pickModels,),
        backgroundColor: RevmoColors.darkBlue,
        body: CarsSelectionWidget(
          selectedCars,
          Provider.of<CatalogProvider>(context, listen: false).catalog,
          Consumer<ModelsProvider>(
            builder: (context, modelsProvider, child) => Container(
                padding: HomeScreen.HORIZONTAL_PADDING,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: (isLoading)
                          ? ListView(children: [HorizontalModelCarsList.placeholder(), HorizontalModelCarsList.placeholder()])
                          : (modelsProvider.brandModels.length > 0)
                              ? ListView.builder(
                                  itemCount: modelsProvider.brandModels.length,
                                  itemBuilder: (context, index) {
                                    if (modelsProvider.brandModels[index].hasCars)
                                      return HorizontalModelCarsList(modelsProvider.brandModels[index]);
                                    else
                                      return Container();
                                  })
                              : NoCarsFound(false),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: MainButton(
                        text: (modelsProvider.brandModels.length > 0)
                            ? AppLocalizations.of(context)!.done
                            : AppLocalizations.of(context)!.back,
                        callBack:
                            (!isLoading) ? (() => (modelsProvider.brandModels.length > 0) ? advanceForm() : goBack()) : null,
                        width: double.infinity,
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
