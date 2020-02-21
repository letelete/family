import 'package:family/base/base_view.dart';
import 'package:family/builder/base_builder_view.dart';
import 'package:family/builder/builder_contract.dart';
import 'package:family/core/models/builder/build_data.dart';
import 'package:family/core/models/builder/builder_page.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FamilyBuilder extends StatelessWidget
    implements BuilderContract<Family, FamilyBuilderModel> {
  final BuilderInitialData<Family> initialData;
  final List<BuilderPageData> Function(FamilyBuilderModel model) pages;
  final String finalStepButtonLabel;
  final String nextStepButtonLabel;

  const FamilyBuilder({
    this.initialData,
    @required this.pages,
    this.finalStepButtonLabel = BuilderContract.defaultCreateLabel,
    this.nextStepButtonLabel = BuilderContract.defaultNextLabel,
  }) : assert(pages != null);

  @override
  Widget build(BuildContext context) {
    return BaseView<FamilyBuilderModel>(
      onModelReady: (model) {
        if (initialData != null) {
          model.initializeFamily(initialData.product);
        }
      },
      builder: (context, model, _) {
        return BaseBuilderView<Family>(
          children: pages(model),
          nextStepButtonLabel: nextStepButtonLabel,
          finalStepButtonLabel: finalStepButtonLabel,
          onFinishBuild: () {
            model.buildFamilyFromStoredFields();
            return model.buildResponse;
          },
        );
      },
    );
  }
}
