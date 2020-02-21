import 'package:flutter/material.dart';

class BuilderPageData {
  final Widget view;
  final String title;
  final bool validated;

  const BuilderPageData({
    @required this.view,
    @required this.title,
    @required this.validated,
  })  : assert(view != null),
        assert(title != null && title.length > 0),
        assert(validated != null);
}
