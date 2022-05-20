import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/catalog.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/providers/catalog_provider.dart';
import 'package:revmo/screens/catalog/model_colors_selection_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/shared/widgets/misc/confirm_dialog.dart';
import 'package:revmo/shared/widgets/misc/danger_button.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/misc/revmo_car_colors_card.dart';
import 'package:revmo/shared/widgets/misc/revmo_car_details_card.dart';
import 'package:revmo/shared/widgets/misc/revmo_car_images_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarDetailsScreenArguments {
  final Car car;
  final List<ModelColor> ownedColors;

  const CarDetailsScreenArguments(this.car, this.ownedColors);
}

class CarDetailsScreen extends StatefulWidget {
  static const ROUTE_NAME = "cardetails";

  final CarDetailsScreenArguments arguments;
  const CarDetailsScreen(this.arguments);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  bool isLoading = false;
  late final Catalog tmpCatalog;

  @override
  void initState() {
    tmpCatalog = new Catalog()..addCarWithColors(widget.arguments.car, widget.arguments.ownedColors);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RevmoAppBar(
        title: widget.arguments.car.carName,
      ),
      backgroundColor: RevmoColors.darkBlue,
      body: Stack(
        alignment: Alignment.center,
        children: [
          ModelColorsSelectionWidget(
            selectedCars: tmpCatalog,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  RevmoCarImagesCard(widget.arguments.car),
                  RevmoCarDetailsCard(widget.arguments.car),
                  RevmoCarColorsCard(widget.arguments.car, initiallySelectedColors: widget.arguments.ownedColors),
                  MainButton(
                    text: AppLocalizations.of(context)!.updateColors,
                    callBack: (!isLoading) ? updateColors : null,
                  ),
                  DangerButton(
                    text: AppLocalizations.of(context)!.removeCar,
                    callBack: (!isLoading)
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    ConfirmDialog(AppLocalizations.of(context)!.removeCarQuestion, () => removeCar()));
                          }
                        : null,
                  )
                ],
              ),
            ),
          ),
          if (isLoading) RevmoTheme.getLoadingContainer(context)
        ],
      ),
    );
  }

  updateColors() async {
    if (tmpCatalog.canSubmitColors()) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<CatalogProvider>(context, listen: false).addCarsToCatalog(tmpCatalog);
      setState(() {
        isLoading = false;
      });
    } else {
      RevmoTheme.showRevmoSnackbar(context, AppLocalizations.of(context)!.cantAddCarsMsg);
    }
  }

  removeCar() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<CatalogProvider>(context, listen: false).removeCar(widget.arguments.car);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }
}
