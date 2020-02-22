import 'package:family/base/base_model.dart';
import 'package:family/base/base_view.dart';
import 'package:family/builder/base_builder_view.dart';
import 'package:family/builder/builder_contract.dart';
import 'package:family/core/models/builder/build_data.dart';
import 'package:family/core/models/builder/builder_page.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:flutter/material.dart';

class MemberBuilder extends StatelessWidget
    implements BuilderContract<Member, MemberBuilderModel> {
  final BuilderInitialData<Member> initialData;
  final List<BuilderPageData> Function(BaseModel model) pages;
  final String finalStepButtonLabel;
  final String nextStepButtonLabel;

  const MemberBuilder({
    this.initialData,
    @required this.pages,
    this.finalStepButtonLabel = BuilderContract.defaultCreateLabel,
    this.nextStepButtonLabel = BuilderContract.defaultNextLabel,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<MemberBuilderModel>(
      onModelReady: (model) {
        if (initialData != null) {
          model.initializeMember(initialData.product);
        }
      },
      builder: (context, model, _) {
        return BaseBuilderView<Member>(
          children: pages(model),
          nextStepButtonLabel: 'Next',
          finalStepButtonLabel: 'Add member',
          onFinishBuild: () {
            model.buildMemberFromStoredFields();
            return model.builderResponse;
          },
        );
      },
    );
  }
}
