import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/brands_provider.dart';
import 'package:revmo/shared/widgets/catalog/brand_tile.dart';

class CatalogGrid extends StatefulWidget {
  final double _tilePadding = 4;
  CatalogGrid();

  @override
  _CatalogGridState createState() => _CatalogGridState();
}

class _CatalogGridState extends State<CatalogGrid> {
  bool isLoadingBrands=true;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
    await Provider.of<BrandsProvider>(context, listen: false).loadBrands();
    isLoadingBrands=false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandsProvider>(builder: (context, brandsProvider, _) {
      return Container(
        child: GridView.count(
            crossAxisCount: 3,
            children: (isLoadingBrands && brandsProvider.brands.isEmpty)
                ? generatePlaceholders(5)
                : brandsProvider.brands
                    .map((e) => Padding(
                          padding: EdgeInsets.all(widget._tilePadding),
                          child: BrandTile(e),
                        ))
                    .toList()),
      );
    });
  }

  List<Widget> generatePlaceholders(int count) {
    List<Widget> ret = [];
    for (int i = 0; i < count; i++)
      ret.add(Padding(padding: EdgeInsets.all(widget._tilePadding), child: BrandTile.placeholder()));
    return ret;
  }
}
