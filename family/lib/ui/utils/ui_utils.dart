import 'package:flutter/material.dart';

class UiUtils {
  /// Returns [List] of [Widget], but with given [spacing] widget inserted between given [children] widgets.
  static List<Widget> getSpacedWidgets({
    @required List<Widget> children,
    @required Widget spacing,
  }) {
    List<Widget> spacedWidgets = [];

    int start = 0;
    int end = children.length - 1;

    for (int index = start; index <= end; ++index) {
      Widget widget = children.elementAt(index);
      
      spacedWidgets.add(widget);

      bool addSpacingAfterwards = index != end;
      if (addSpacingAfterwards) {
        spacedWidgets.add(spacing);
      }
    }

    return spacedWidgets;
  }
}
