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
    return Container(color:Colors.yellow[500]);

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
