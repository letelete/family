import 'package:family/base/builder/base_page_view.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:family/ui/widgets/builder_day_selection_widget.dart';
import 'package:flutter/material.dart';

class MemberPaymentDayPage extends StatelessWidget {
  static const String title = 'What\'s his payment day?';
  final MemberBuilderModel model;

  const MemberPaymentDayPage(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate =
        model.memberNextPayment ?? model.member?.nextPayment;
    final double buttonOpacity = selectedDate == null ? 0.34 : 1.0;
    final String buttonLabel = selectedDate == null
        ? 'Tap to select the payment day'
        : selectedDate.day.toString();
    final DateTime initialDate = selectedDate ?? DateTime.now();

    final BuilderDaySelection dayPicker = BuilderDaySelection(
      context: context,
      daysSelectionLimit: 28,
      initialDate: initialDate,
    );

    return BaseBuilderPageView<FamilyBuilderModel>(builder: (context) {
      return InkWell(
        onTap: () async {
          DateTime date = await dayPicker.show();
          bool isNewDateValid = model.validatePaymentDay(date);
          if (isNewDateValid) model.savePaymentDay(date);
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
    });
  }
}
