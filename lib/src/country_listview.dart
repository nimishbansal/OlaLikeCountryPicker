import 'package:flutter/material.dart';

import 'Models/country.dart';
import 'Repository/countries_json.dart';

/// Signature used by [CountryListView] to indicate which country has been selected
///
/// Used by [CountryListView.onSelected].
///
/// Called when the country has been selected.
typedef OnCountrySelectedCallback = Function(Country country);

/// Signature used by [CountryListView] to give the application an opportunity to create their
/// own version of listItem used in [_CountryListViewState.build]
///
/// Used by [CountryListView.itemBuilder] in [_CountryListViewState._buildListItem]
typedef ListItemBuilder = Widget Function(
    BuildContext context, int index, Country country);

enum ListItemFlagTitleCodeOrder {
  ///DialCode first, then Country name, then Flag
  dialCodeToTileToFlag,

  ///Flag first, then Country name, then DialCode
  flagToTitleToDialCode
}

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
  OnCountrySelectedCallback onSelected;

  /// builder for making own version of country list item e.g
  /// ```dart
  /// CountryListView(
  ///   itemBuilder : (BuildContext context, int index, Country country){
  ///          return new ListTile(
  ///            title: new Text(country.name, style: widget.itemTitleStyle,),
  ///            onTap: (){
  ///              widget.onSelected(country);
  ///            }
  ///          );
  ///       },
  /// )
  /// ```
  ///
  /// When itemBuilder is provided by the application properties like
  /// [flagWidth], [flagHeight], [showFlag], [showDialCode], [itemTitleStyle]
  /// e.t.c won't work.
  final ListItemBuilder itemBuilder;

  /// It is base path where all the images(.png) of all the flags are present with filename as their
  /// country codes
  final flagBasePath;

  final double flagWidth;
  final double flagHeight;
  final bool showFlag;
  final bool showDialCode;

  /// It is a prefix that is prepended to each countryDialCode
  /// By default it is '+'
  final String dialCodePrefix;

  /// It gives application an opportunity to give style to title of the country in listItem
  final TextStyle itemTitleStyle;

  /// It gives application an opportunity to give style to dialCode of the country in listItem
  final TextStyle dialCodeStyle;

  final ListItemFlagTitleCodeOrder flagTitleCodeOrder;

  final bool primary;

  final bool shrinkWrap;

  ScrollPhysics scrollPhysics;

  final ScrollController scrollController;
  CountryListView({
    Key key,
    this.countryJsonList = countryCodes,
    this.backgroundColor = Colors.white,
    this.onSelected,
    this.itemBuilder,
    this.flagBasePath = "assets/images/flags/",
    this.flagWidth = 25,
    this.flagHeight = 25,
    this.showFlag = true,
    this.showDialCode = true,
    this.dialCodePrefix = '+',
    this.itemTitleStyle,
    this.dialCodeStyle,
    this.flagTitleCodeOrder = ListItemFlagTitleCodeOrder.flagToTitleToDialCode,
    this.scrollPhysics,
    this.primary = false,
    this.scrollController,
    this.shrinkWrap = false
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
  Widget getFlag(Country country) {
    String flagPath = "${widget.flagBasePath}${country.code.toLowerCase()}.png";
    return Container(
      width: widget.flagWidth,
      height: widget.flagHeight,
      child: Image(
        image: new AssetImage(flagPath, package: 'ola_like_country_picker'),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index, Country country) {
    if (widget.itemBuilder != null) {
      // Use itemBuilder by the application, if provided.
      return widget.itemBuilder(context, index, country);
    } else {
      Widget leadingWidget;
      Widget trailingWidget;
      String fullDialCode;
      fullDialCode = widget.dialCodePrefix + country.dialCode;
      if (widget.flagTitleCodeOrder ==
          ListItemFlagTitleCodeOrder.flagToTitleToDialCode) {
        leadingWidget = widget.showFlag ? getFlag(country) : null;
        trailingWidget = widget.showDialCode
            ? Text(
                fullDialCode,
                style: widget.dialCodeStyle,
              )
            : null;
      } else {
        leadingWidget = widget.showDialCode
            ? Text(
                fullDialCode,
                style: widget.dialCodeStyle,
              )
            : null;
        trailingWidget = widget.showFlag ? getFlag(country) : null;
      }

      return new ListTile(
          leading: leadingWidget,
          title: new Text(
            country.name,
            style: widget.itemTitleStyle,
          ),
          trailing: trailingWidget,
          onTap: () {
            widget.onSelected(country);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
          shrinkWrap: widget.shrinkWrap,
          controller: widget.scrollController,
          primary: widget.primary,
          physics: widget.scrollPhysics,
          itemCount: widget.countries.length,
          itemBuilder: (context, index) {
            return _buildListItem(context, index, widget.countries[index]);
          }),
    );
  }
}
