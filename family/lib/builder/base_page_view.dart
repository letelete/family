import 'package:family/base/base_model.dart';
import 'package:flutter/material.dart';

/// Describes the most basic layout of [BaseBuilderView].
///
/// Aligns its child in the center of the layout,
/// and creates transparent background to expose [BaseBuilderView] background.
///
/// All pages should return the [BaseBuilderPageView] as a parent view.
class BaseBuilderPageView<T extends BaseModel> extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const BaseBuilderPageView({Key key, this.builder})
      : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: builder(context),
    );
  }
}
