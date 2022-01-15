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
          itemCount: catalogProvider.filteredCatalog.length,
          itemBuilder: (cntx, index) => CatalogTile(catalogProvider.filteredCatalog[index],
              catalogProvider.catalog.getCarColors(catalogProvider.filteredCatalog[index]))),
    );
  }
}
