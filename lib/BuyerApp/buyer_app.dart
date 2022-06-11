

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Buyer/home_provider.dart';



class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){
        customerProvider.setAppBar();
        Navigator.pop(context,);

      },icon:Icon(Icons.arrow_back) ,),),
    );
  }
}
