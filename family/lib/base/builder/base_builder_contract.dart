import 'package:family/core/models/build_data/build_data.dart';
import 'package:flutter/material.dart';

/// Describes all requirements of creating [BaseBuilderView].
/// 
/// All builder views creating [BaseBuilderView] should extend this class.
abstract class BaseBuilderContract<T extends BuildData> extends StatefulWidget {
  /// The data passed into the creational view of the [BaseBuilderView].
  /// See also:
  /// * [BuildData], where the logic behind [initialData] is hosted.
  final T initialData;

  const BaseBuilderContract({Key key, this.initialData}) : super(key: key);
}