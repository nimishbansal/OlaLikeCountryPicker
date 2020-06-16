import 'package:flutter/material.dart';
import 'package:ola_like_country_picker/ola_like_country_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CountryPicker c;
  Country country = Country.fromJson(countryCodes[94]);

  @override
  void initState() {
    super.initState();
    c = CountryPicker(onCountrySelected: (Country country) {
      print(country);
      setState(() {
        this.country = country;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage(country.flagUri, package: 'ola_like_country_picker'),
          ),
        ),
      ),
      onTap: () {
        c.launch(context);
      },
    );
  }
}
