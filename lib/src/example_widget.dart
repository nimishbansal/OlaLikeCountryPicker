import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'country_listview.dart';

class ExampleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExampleWidgetState();
  }
}

class ExampleWidgetState extends State<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
    var json = [
      {"Name": "Afghanistan", "ISO": "af", "Code": "93"},
      {"Name": "Albania", "ISO": "al", "Code": "355"},
      {"Name": "Algeria", "ISO": "dz", "Code": "213"},
      {"Name": "India", "ISO": "in", "Code": "91"},
      {"Name": "Afghanistan", "ISO": "af", "Code": "93"},
      {"Name": "Albania", "ISO": "al", "Code": "355"},

    ];
    return GestureDetector(onTap: () {
      var snackBar = SnackBar(
          backgroundColor: Colors.white,
        content: Container(
            height: 220,
          child: CountryListView(
            countryJsonList: json,
              itemTitleStyle: TextStyle(color: Colors.black),
              dialCodeStyle: TextStyle(color:Colors.black),
          ),
        ),
          duration: Duration(milliseconds: 5500),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
//      return CountryListView(flagWidth: 50,
//          flagHeight: 50,
//          showFlag: true,
//          showDialCode: true,
//          itemTitleStyle: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//          dialCodeStyle: TextStyle(fontSize: 16),
//          flagTitleCodeOrder: ListItemFlagTitleCodeOrder.dialCodeToTileToFlag,
//      );
//      return CountryListView(itemBuilder: (context, index, country){
//          return Text("ho"+ country.name);
//      },);
//  }
}
