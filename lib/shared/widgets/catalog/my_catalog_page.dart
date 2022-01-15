import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/catalog_provider.dart';
import 'package:revmo/shared/widgets/catalog/catalog_tile.dart';

class MyCatalogPage extends StatelessWidget {
  const MyCatalogPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (cnxt, catalogProvider, _) => ListView.builder(
          itemCount: catalogProvider.catalog.length,
          itemBuilder: (cntx, index) =>
              CatalogTile(catalogProvider.catalog[index], catalogProvider.catalog.getCarColors(catalogProvider.catalog[index]))),
    );
  }
}
