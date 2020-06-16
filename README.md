Ola Like Country Picker
==========================

A new country picker Flutter package built in Dart.

## Introduction
It is Flutter plug-n-play country picker package.

0. Simple two lines of code. Initialize and Launch.
```dart
CountryPicker countryPicker = CountryPicker(
                                onCountrySelected:(country){
                                    print(country);
                                },
                              );
countryPicker.launch(context)
```

## Installation
https://pub.dev/packages/ola_like_country_picker#-installing-tab-



1. To use the Country Picker look at the example below :

### Example Usage:
```dart
class _MyHomePageState extends State<MyHomePage> {
  CountryPicker countryPicker;
  Country country = Country.fromJson(countryCodes[0]); // select initial country 

  @override
  void initState() {
    super.initState();
    countryPicker = CountryPicker(onCountrySelected: (Country country) {
      print(country);
      setState(() {
        this.country = country;
      });
    });
  }
  
    @override
  Widget build(BuildContext context) {
    // To simply launch the country picker
    // use countryPicker.launch(context)
    // to forcefully dismiss use countryPicker.dismiss()
    // simple example could be
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
        countryPicker.launch(context);
      },
    );

  }  
}
```

### Output

<img src="https://user-images.githubusercontent.com/20876020/67149539-030cd900-f2ca-11e9-981a-f158e63bacd1.gif" width="30%" height="60%"/>
          

### Parameters
| parameter         | default               | required  | type                      | remark                                                                                                                                              |
|-------------------|-----------------------|-----------|---------------------------|----------------------------------
| onCountrySelected |        null           |    yes    | OnCountrySelectedCallback | called when country is selected.                                                      |
| showTitle         |       true            |    no     | bool                      | whether to show title or not.                                                                                                                                       |
| titleText         | "Select your country" |    no     | String                    | text for title.                                                                                                                        |




2. To simply use country list view any where use CountryListView() and to modify attributes like flagWidth, flagHeight, countryTitle style etc use below arguments like
```dart
CountryListView(flagWidth:50, flagHeight:50 , itemTitleStyle: TextStyle(fontSize:20)); 
```

### Example Usage:
```dart
return MaterialApp(
  theme: ThemeData(primarySwatch: Colors.purple),
  home: Scaffold(
    appBar: AppBar(
      title: Text('Select Country'),
    ),
    body: CountryListView(),
  ),
);
```

### Output
<img src="https://user-images.githubusercontent.com/20876020/65821688-6b7e1280-e256-11e9-993a-a4847acb8859.gif" width="30%" height="60%"/>

### Parameters
| parameter       | default       | required | type                      | remark                                                                                                                                              |
|-----------------|---------------|----------|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| countryJsonList | country_codes | no       | List<Map<String, String>> | can be used to specify own set of sublist of countries from the variable country_codes                                                      |
| flagWidth       |       25      | no       | double                    | width of flag                                                                                                                                       |
| flagHeight      |       25      | no       | double                    | height of flag                                                                                                                                      |
| showFlag        |      true     | no       | bool                      | whether to show flag or not                                                                                                                         |
| showDialCode    |      true     | no       | bool                      | whether to show dial code or not                                                                                                                    |
| dialCodePrefix  |      '+'      | no       | String                    | The prefix added to the dial code for e.g +91 here prefix is '+'                                                                                    |
| itemTitleStyle  |      null     | no       | TextStyle                 | Used to change style of Country title e.g TextStyle(fontSize:30)                                                                                    |
| dialCodeStyle   |      null     | no       | TextStyle                 | Used to change style of Country's dial code e.g TextStyle(backgroundColor:Colors.green[400])                                                        |
| onSelected      |      null     | no       | OnCountrySelectedCallback | When Any Country is selected what callback has to be executed e.g CountryListView(onSelected: (Country country){       print(country.toString() }); |



3. To use the own version of CountryListView() with CountryPicker() use setCountryListView() method before calling launch()
e.g.
```dart
    c = CountryPicker(onCountrySelected: (Country country) {
      print(country);
      setState(() {
        this.country = country;
      });
    });
    CountryListView clv = CountryListView(showFlag:false); //own version of CountryListView
    c.setCountryListView(clv);
    ...
    ...
    // Call c.launch(context) in GestureDetector() or other listeners 
    ...
    ...
    
 ```
    
## Support

The simplest way to show your support is by giving the project a star.

You can also support by becoming a patron on Patreon:

[![Patreon](https://c5.patreon.com/external/logo/become_a_patron_button.png)](https://www.patreon.com/nimishbansal)

Or by making a single donation by buying a coffee:

[![Buy Me A Coffee](https://cdn.buymeacoffee.com/buttons/default-orange.png)](https://www.buymeacoffee.com/nimishbansal)
