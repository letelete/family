import 'package:family/base/base_model.dart';
import 'package:family/core/models/builder/builder_page.dart';

/// All classes which construct builder pages should extend this class.
abstract class BasePageCreator<T extends BaseModel> {
  const BasePageCreator();
  T get model;
  List<BuilderPageData> allPages();
}
