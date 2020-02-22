import 'package:family/core/enums/build_responses.dart';

class BuilderResponse<T> {
  /// Describes a response of the build process.
  final BuildResponse response;

  /// See:
  /// * [BuildData], where the logic behind [T] is hosted.
  final T product;

  const BuilderResponse({this.response, this.product});
}
