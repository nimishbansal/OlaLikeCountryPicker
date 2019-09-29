Ola Like Country Picker
==========================

A new Flutter package to select country from list of countries.

## Introduction
It is Flutter package made in Dart to have plug-n-play CountryPicker tool.

1. To simply use country list view any where use CountryListView() 

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
