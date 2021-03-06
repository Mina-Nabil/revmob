import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/catalog_provider.dart';
import 'package:revmo/shared/widgets/catalog/catalog_tile.dart';

class MyCatalogPage extends StatelessWidget {
  const MyCatalogPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (cnxt, catalogProvider, _) => ListView.builder(
          itemCount: catalogProvider.filteredCatalog.length,
          itemBuilder: (cntx, index) => FadeInUp(
            child: CatalogTile(
                catalogProvider.filteredCatalog[index],
                catalogProvider.catalog.getCarColors(catalogProvider.filteredCatalog[index])),
          )),
    );
  }
}
