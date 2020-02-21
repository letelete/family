import 'package:family/base/base_model.dart';

/// Describes a contract for a single page of the [BaseBuilderView].
abstract class BuilderPageContract<T extends BaseModel> {
  String get title;
  T get model;
}
