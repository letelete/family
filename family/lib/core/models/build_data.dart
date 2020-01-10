import 'package:family/core/enums/build_responses.dart';

/// Specifies the contract between the creational screen of [BaseBuilderView]
/// and other app components.
///
/// The need of having an initial data might be mandatory,
/// with consecutive screens of the [BaseBuilderView] which need additional data to
/// be created, or with those which are responsible for editing already constructed models.
class BuildData<T> {
  /// The product you want to build using [BaseBuilderView].
  /// Can be null, if the product itself is going to be constructed from scratch,
  /// and no initial data is required.
  final T product;

  /// Describes a response of the build process.
  final BuildResponses response;

  const BuildData({this.product, this.response});
}
