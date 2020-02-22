import 'package:family/base/base_model.dart';
import 'package:family/core/models/builder/build_data.dart';
import 'package:family/core/models/builder/builder_page.dart';

/// Describes contract for a view class building [BaseBuilderView].
///
/// All views returning [BaseBuilderView] should implement this class.
abstract class BuilderContract<ProductType, Model extends BaseModel> {
  static const String defaultNextLabel = 'Next';
  static const String defaultCreateLabel = 'Create';
  static const String defaultUpdateLabel = 'Update';

  BuilderInitialData<ProductType> get initialData;
  List<BuilderPageData> Function(Model model) get pages;
  String get nextStepButtonLabel;
  String get finalStepButtonLabel;
}
