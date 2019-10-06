import 'package:flutter/material.dart';

import 'country_picker.dart';

class ExampleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExampleWidgetState();
  }
}

class ExampleWidgetState extends State<ExampleWidget> {
  CountryPicker c;

  @override
  void initState() {
    super.initState();
    c = CountryPicker();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(color: Colors.yellow[500]),
        onTap: () {
          c.launch(context);
          Future.delayed(Duration(seconds: 4), () {
            c.dismiss();
          });
        });
  }
}
