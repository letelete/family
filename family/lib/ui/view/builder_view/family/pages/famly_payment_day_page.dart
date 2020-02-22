import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:flutter/material.dart';

class FamilyPaymentDayPage extends StatelessWidget
    implements BuilderPageContract<FamilyBuilderModel> {
  final FamilyBuilderModel model;

  const FamilyPaymentDayPage(this.model, {Key key}) : super(key: key);

  @override
  String get title => 'What\'s the next payment day?';

  @override
  Widget build(BuildContext context) {
    const int lastEnabledDayOfMonth = 28;
    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
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
          final date = await getPaymentDay;
          model.onPaymentDayChange(date);
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
      },
    );
  }
}
