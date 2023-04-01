import 'package:flutter/cupertino.dart';

extension WidgetExtension on Widget {
  Widget addPadding(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Padding(
        padding:
            EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this);
  }

  Widget addVerticalPadding(
    double padding,
  ) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: padding), child: this);
  }

  Widget addHorizontalPadding(
    double padding,
  ) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding), child: this);
  }

  Widget addAllPadding(
    double padding,
  ) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  Widget wrapByContainer({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: this,
    );
  }

  Widget wrapByExpanded({int? flex}) {
    return Expanded(flex: flex ?? 1, child: this);
  }
}
