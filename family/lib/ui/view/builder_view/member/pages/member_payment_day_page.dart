import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:family/ui/widgets/builder_day_selection_widget.dart';
import 'package:flutter/material.dart';

class MemberPaymentDayPage extends StatelessWidget
    implements BuilderPageContract<MemberBuilderModel> {
  final MemberBuilderModel model;

  const MemberPaymentDayPage(this.model, {Key key}) : super(key: key);

  @override
  String get title => 'What\'s his payment day?';

  @override
  Widget build(BuildContext context) {
    final selectedDate = model.memberNextPayment;
    final buttonOpacity = selectedDate == null ? 0.34 : 1.0;
    final buttonLabel = selectedDate == null
        ? 'Tap to select the payment day'
        : selectedDate.day.toString();

    final dayPicker = BuilderDaySelection(
      context: context,
      daysSelectionLimit: 28,
      initialDate: selectedDate,
    );

    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
        return InkWell(
          onTap: () async {
            DateTime date = await dayPicker.show();
            model.onPaymentDayChange(date);
          },
          child: Opacity(
            opacity: buttonOpacity,
            child: Container(
              child: Text(
                buttonLabel,
                textAlign: TextAlign.center,
                style: AppStyles.menuActiveContentText,
              ),
            ),
          ),
        );
      },
    );
  }
}
