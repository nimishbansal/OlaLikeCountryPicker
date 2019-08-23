import 'package:flutter/material.dart';

import 'Models/country.dart';
import 'Repository/countries_json.dart';

/// Signature used by [CountryListView] to indicate which country has been selected
///
/// Used by [CountryListView.onSelected].
///
/// Called when the country has been selected.
typedef OnSelectedCallback = Future<bool> Function(Country country);

/// Signature used by [CountryListView] to give the application an opportunity to create their
/// own version of listItem used in [_CountryListViewState.build]
///
/// Declared in [CountryListView.itemBuilder]
/// Used by [_CountryListViewState._buildListItem]
typedef ListItemBuilder = Widget Function(BuildContext context, int index);

/// A widget that is used to display list of countries with their flags, name and mobile codes.
///
/// When a list item in this widget is tapped it causes the country to be selected and executes
/// [onSelected] callback
// ignore: must_be_immutable
class CountryListView extends StatefulWidget {
  /// Json List of Countries Details
  ///
  /// e.g
  /// ```dart
  /// [
  /// {"Name": "Afghanistan", "ISO": "af", "Code": "93"},
  /// {"Name": "Albania", "ISO": "al", "Code": "355"},
  /// {"Name": "Algeria", "ISO": "dz", "Code": "213"},
  /// ]
  /// ```
  final List<Map> countryJsonList;

  /// List of Country instances from the [countryJsonList]
  List<Country> countries;

  /// background of list tile in list view
  final Color backgroundColor;

  /// Called when the country has been selected
  final OnSelectedCallback onSelected;

  final ListItemBuilder itemBuilder;

  CountryListView({
    Key key,
    this.countryJsonList = country_codes,
    this.backgroundColor = Colors.white,
    this.onSelected,
    this.itemBuilder,
  })  : countries = countryJsonList
            .map((countryData) => Country.fromJson(countryData))
            .toList(),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CountryListViewState();
  }
}

class _CountryListViewState extends State<CountryListView> {
  Widget _buildListItem(BuildContext context, int index) {
    if (widget.itemBuilder != null) {
      // Use itemBuilder by the application, if provided.
      return widget.itemBuilder(context, index);
    } else {
      Country country = widget.countries[index];
      return new ListTile(
        title: new Text(country.name),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.countries.length,
        itemBuilder: (context, index) {
          return _buildListItem(context, index);
        });
  }
}
