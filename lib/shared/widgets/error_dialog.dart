import 'package:flutter/material.dart';
class ErrorDialog extends StatelessWidget {
  final Map<String, dynamic> errors;

  const ErrorDialog(this.errors);

  @override
  Widget build(BuildContext context) {
    List<Widget> errorsList = [];
    errors.forEach((k, v) {
      errorsList.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Text(v.toString()),
      ));
    });
    return AlertDialog(
      
      title: Text("Oops"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: errorsList,
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("OK"))
      ],
    );
  }
}
