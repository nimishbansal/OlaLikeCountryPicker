import 'package:flutter/foundation.dart';

class Country {
  String name;
  String code;
  String dialCode;
  String extra;

  Country({
    @required this.name,
    @required this.code,
    @required this.dialCode,
    this.extra,
  });

  @override
  String toString() {
    return dialCode + code;
  }

  Country.fromJson(Map<dynamic, dynamic> countryData) {
    name = countryData['Name'];
    code = countryData['ISO'];
    dialCode = countryData['Code'];
  }

  String get flagUri => "assets/images/flags/${code.toLowerCase()}.png";
}
