import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      return Container(color: Colors.black54, width: 200,height: 200,);
  }
}