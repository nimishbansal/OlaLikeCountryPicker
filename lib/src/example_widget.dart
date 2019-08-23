import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'country_listview.dart';

class ExampleWidget extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
   return ExampleWidgetState();
  }
}

class ExampleWidgetState extends State<ExampleWidget>{
  @override
  Widget build(BuildContext context) {
      return CountryListView();
  }
}
