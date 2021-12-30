import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/brand.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/models/catalog.dart';
import 'package:revmo/providers/models_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/screens/home/model_colors_selection_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/catalog/horizontal_model_cars_list.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarsSelectionWidget extends InheritedWidget {
  final Catalog selectedCars;

  CarsSelectionWidget(this.selectedCars, Widget child) : super(child: child);

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

  toggleCar(Car c) {
    if (selectedCars.hasCar(c))
      selectedCars.removeCar(c);
    else
      selectedCars.addCar(c);
  }
}

class BrandModelsScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/model/brands";
  final Brand _brand;
  const BrandModelsScreen({required Brand brand}) : this._brand = brand;

  @override
  _BrandModelsScreenState createState() => _BrandModelsScreenState();
}

class _BrandModelsScreenState extends State<BrandModelsScreen> {
  late Catalog selectedCars;
  bool isLoading = true;
  bool canAdvance = false;
  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
        canAdvance = false;
      });
      await Provider.of<ModelsProvider>(context, listen: false).loadModels(widget._brand.id, true);
      //load catalog
      setState(() {
        isLoading = false;
        canAdvance = false;
      });
    });
    selectedCars = new Catalog();
    super.initState();
  }

  advanceForm() {
    if (selectedCars.length > 0) {
      Navigator.of(context).push(PageTransition(child: ModelColorsSelectionsScreen(selectedCars), type: PageTransitionType.rightToLeft));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(AppLocalizations.of(context)!.emptyCarsList)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RevmoAppBar(),
        backgroundColor: RevmoColors.darkBlue,
        body: CarsSelectionWidget(
          selectedCars,
          Container(
            padding: HomeScreen.HORIZONTAL_PADDING,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: Consumer<ModelsProvider>(
                      builder: (context, modelsProvider, child) => (isLoading)
                          ? ListView(children: [HorizontalModelCarsList.placeholder(), HorizontalModelCarsList.placeholder()])
                          : ListView.builder(
                              itemCount: modelsProvider.brandModels.length,
                              itemBuilder: (context, index) {
                                if (modelsProvider.brandModels[index].hasCars)
                                  return HorizontalModelCarsList(modelsProvider.brandModels[index]);
                                else
                                  return Container();
                              })),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: MainButton(
                    text: AppLocalizations.of(context)!.done,
                    callBack: (!isLoading) ? () => advanceForm() : null,
                    width: double.infinity,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
