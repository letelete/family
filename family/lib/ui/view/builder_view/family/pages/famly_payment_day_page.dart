import 'package:family/base/builder/base_page_view.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:flutter/material.dart';

class FamilyPaymentDayPage extends StatelessWidget {
  static const String title = 'What\'s the next payment day?';

  final FamilyBuilderModel model;

  const FamilyPaymentDayPage({
    Key key,
    this.model,
  })  : assert(model != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBuilderPageView<FamilyBuilderModel>(builder: (context) {
      const int lastEnabledDayOfMonth = 28;

      final DateTime passedPaymentDay = model.family?.paymentDay;

      final bool paymentDaySelected = model.paymentDay != null;
      final double buttonOpacity = paymentDaySelected ? 1.0 : 0.34;
      final String buttonLabel = paymentDaySelected
          ? model.paymentDay.day.toString()
          : 'Tap to select day';
      final DateTime initialDate = paymentDaySelected
          ? model.paymentDay
          : passedPaymentDay ?? DateTime.now();
      final DateTime firstDate = DateTime(initialDate.year);
      final DateTime lastDate = DateTime(initialDate.year + 1);

      Future<void> selectDate() async {
        Future<DateTime> getPaymentDay = showDatePicker(
          selectableDayPredicate: (DateTime val) =>
              val.day <= lastEnabledDayOfMonth,
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark(),
              child: child,
            );
          },
        );

        await getPaymentDay.then(model.validatePaymentDayAndSave);
      }

      return InkWell(
        onTap: selectDate,
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
