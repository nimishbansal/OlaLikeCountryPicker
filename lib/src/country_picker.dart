import 'dart:async';
import 'package:flutter/material.dart';

import 'Models/country.dart';
import 'country_listview.dart';

enum _FlingGestureKind { none, fling_down, fling_up }
const double _kMinFlingVelocity = 700.0;
const _kGreyOpacity = Color.fromRGBO(129, 129, 129, 0.5);
const _kTransitionDuration = Duration(milliseconds: 300);

/// Used by [CustomScrollPhysics.createBallisticSimulation]
/// * See Also :
/// https://github.com/flutter/flutter/blob/2d2a1ffec9/packages/flutter/lib/src/widgets/dismissible.dart#L375
_FlingGestureKind _describeFlingGesture(double velocity) {
  final double vy = velocity;
  if (vy.abs() < _kMinFlingVelocity) return _FlingGestureKind.none;
  if (vy < 0)
    return _FlingGestureKind.fling_down;
  else if (vy > 0)
    return _FlingGestureKind.fling_up;
  else
    return _FlingGestureKind.none;
}

class _CountryPickerWidget extends StatefulWidget {
  /// how much drag extent is necessary to expand the sheet
  final double dismissThreshold;

  final OnCountrySelectedCallback onSelected;

  final BuildContext context;

  /// [CountryListView] being used in this Widget
  final CountryListView countryListView;

  /// Used when this widget is initialized by [CountryPicker]
  final CountryPicker countryPickerUtil;

  const _CountryPickerWidget({
    Key key,
    this.dismissThreshold = 50,
    this.onSelected,
    this.context,
    this.countryListView,
    this.countryPickerUtil,
  })  : assert(onSelected != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CountryPickerWidgetState(this.countryListView, context);
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  final _CountryPickerWidgetState countryPickerWidgetState;

  const CustomScrollPhysics(
      {this.countryPickerWidgetState, ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) => CustomScrollPhysics(
      countryPickerWidgetState: countryPickerWidgetState,
      parent: buildParent(ancestor));

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (countryPickerWidgetState.height >= countryPickerWidgetState.maxHeight) {
      // Dragging down the list view when position in list view is at leading edge
      if (offset.sign == 1.0 && position.atEdge && position.pixels == 0.0) {
        this.countryPickerWidgetState.changeHeightWhenDragged(-offset);
        return 0;
      }
      return super.applyPhysicsToUserOffset(position, offset);
    } else {
      this.countryPickerWidgetState.changeHeightWhenDragged(-offset);
      return 0;
    }
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (_describeFlingGesture(velocity) == _FlingGestureKind.fling_up) {
      if (position.pixels == 0.0 &&
          countryPickerWidgetState.height <
              countryPickerWidgetState.maxHeight) {
        countryPickerWidgetState.maximizeSheetHeight();
        return null;
      }
    } else if (_describeFlingGesture(velocity) ==
        _FlingGestureKind.fling_down) {
      if (position.pixels == 0) {
        this.countryPickerWidgetState.minimizeSheetHeight();
        return null;
      }
    } else if (_describeFlingGesture(velocity) == _FlingGestureKind.none) {
      //Maximize or minimize when drag gesture is ended without fling.
      //Either it maximizes or minimizes depending on current position and dismiss threshold
      double dismissThreshold =
          countryPickerWidgetState.widget.dismissThreshold;
      if (position.pixels == 0 &&
          !this.countryPickerWidgetState.motionUnderway) {
        var maxMinHeightDifference = (countryPickerWidgetState.maxHeight -
            countryPickerWidgetState.minHeight);
        var offset = (countryPickerWidgetState.height -
            countryPickerWidgetState.minHeight);

        if (((offset / maxMinHeightDifference) * 100) > dismissThreshold &&
            countryPickerWidgetState.height !=
                countryPickerWidgetState.maxHeight)
          countryPickerWidgetState.maximizeSheetHeight();
        else if (((offset / maxMinHeightDifference) * 100) <=
                dismissThreshold &&
            countryPickerWidgetState.height !=
                countryPickerWidgetState.minHeight)
          countryPickerWidgetState.minimizeSheetHeight();

        return null;
      }
    }

    var result = super.createBallisticSimulation(position, velocity);
    if (result.runtimeType == ClampingScrollSimulation &&
        velocity.abs() > 0 &&
        velocity.abs() < _kMinFlingVelocity) {
      return null;
    }
    return result;
  }
}

/// Modifies the Scroll Behaviour of [CountryListView].
///
/// Removes Glowing effect on Overscroll.
/// See Also:
/// * https://stackoverflow.com/a/51119796/7698247
class _CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _CountryPickerWidgetState extends State<_CountryPickerWidget> {
  /// Maximum Height of the Container in which the list view is wrapped
  double maxHeight;

  /// Minimum Height of the Container in which the list view is wrapped
  double minHeight;

  /// Current height of Container in which list view is wrapped
  ///
  /// It is dynamic and changes linearly when it is being dragged and changes cubically
  ///  when flung or released.
  double height;

  /// true if container in which the list view is wrapped is moving
  bool motionUnderway = false;

  /// Dynamic duration to be used while flinging or dragging
  Duration duration = Duration.zero;

  /// Curve to be used by AnimatedContainer
  Curve curve = Curves.linear;

  CountryListView countryListView;

  _CountryPickerWidgetState(CountryListView countryListView, context) {
    maxHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    minHeight = 240;
    height = minHeight;

    if (countryListView == null) {
      this.countryListView = CountryListView();
    } else {
      this.countryListView = countryListView;
    }
    // Attribute scrollPhysics must be of type CustomScrollPhysics when list view is
    // provided by user
    this.countryListView.scrollPhysics =
        CustomScrollPhysics(countryPickerWidgetState: this);
    this.countryListView.onSelected = _handleOnCountrySelect;
  }

  /// Change the height of AnimatedContainer linearly while dragging.
  changeHeightWhenDragged(double offset) {
    setState(() {
      height += offset;
    });
  }

  /// Expands CountryListView to occupy full Screen animatedly with ease-curve.
  void maximizeSheetHeight() {
    setState(() {
      motionUnderway = true;
      duration = _kTransitionDuration;
      curve = Curves.ease;
      height = maxHeight;
    });
    Future.delayed(_kTransitionDuration, () {
      setState(() {
        motionUnderway = false;
        duration = Duration.zero;
        curve = Curves.linear;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  /// Minimizes the CountryListView height to occupy fraction of bottom.
  void minimizeSheetHeight() {
    setState(() {
      motionUnderway = true;
      duration = _kTransitionDuration;
      curve = Curves.ease;
      height = minHeight;
    });
    Future.delayed(_kTransitionDuration, () {
      setState(() {
        motionUnderway = false;
        duration = Duration.zero;
        curve = Curves.linear;
      });
    });
  }

  _handleOnCountrySelect(Country country) {
    if (widget.countryPickerUtil != null) {
      widget.countryPickerUtil.dismiss();
    }
    widget.onSelected(country);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Opacity
        GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: _kGreyOpacity,
          ),
          onTap: () {
            widget.countryPickerUtil.dismiss();
          },
        ),

        // Bottom Sheet
        Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              elevation: 10,
              child: AnimatedContainer(
                color: Colors.white,
                duration: duration,
                curve: curve,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    widget.countryPickerUtil.showTitle
                        ? Padding(
                            child: Text(
                              widget.countryPickerUtil.titleText,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            padding: EdgeInsets.only(top: 12, left: 12),
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    Expanded(
                      child: ScrollConfiguration(
                          behavior: _CustomScrollBehavior(),
                          child: this.countryListView),
                    ),
                  ],
                ),
                height: height,
              ),
            )),
      ],
    );
  }
}

class CountryPicker {
  /// Overlay Entry to display [_CountryPickerWidget] over the app.
  OverlayEntry overlayEntry;

  /// Actual [CountryListView] view to be used in [_CountryPickerWidget].
  CountryListView countryListView;

  /// Called when country has been selected.
  OnCountrySelectedCallback _onCountrySelected;

  /// Title above [CountryListView] in [CountryPicker] widget.
  ///
  ///  By default titleText is "Select your Country"
  String titleText = 'Select Your Country';

  /// Determines whether the [titleText] will be visible above the
  /// [CountryListView] widget.
  bool showTitle = true;

  CountryPicker({
    OnCountrySelectedCallback onCountrySelected,
    String titleText,
    bool showTitle,
  }) {
    this.countryListView = CountryListView();
    this._onCountrySelected = onCountrySelected;
    this.titleText = titleText ?? this.titleText;
    this.showTitle = showTitle ?? this.showTitle;
  }

  void setCountryListView(CountryListView countryListView) {
    assert(
        countryListView.onSelected == null || this._onCountrySelected == null);
    this.countryListView = countryListView;
    if (countryListView.onSelected != null)
      this._onCountrySelected = countryListView.onSelected;
  }

  void launch(BuildContext context) {
    overlayEntry = new OverlayEntry(builder: _builder);
    Overlay.of(context).insert(overlayEntry);
  }

  void dismiss() {
    overlayEntry.remove();
  }

  Widget _builder(BuildContext context) {
    return _CountryPickerWidget(
      context: context,
      onSelected: _onCountrySelected,
      countryPickerUtil: this,
      countryListView: countryListView,
    );
  }
}
