import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/consts.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:family/ui/widgets/date_picker_dialog.dart';
import 'package:flutter/material.dart';

class FamilyPaymentDayPage extends StatelessWidget
    implements BuilderPageContract<FamilyBuilderModel> {
  final FamilyBuilderModel model;

  const FamilyPaymentDayPage(this.model, {Key key}) : super(key: key);

  @override
  String get title => 'What\'s the next payment day?';

  @override
  Widget build(BuildContext context) {
    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
        final selectedPaymentDay = model.paymentDay;
        final buttonOpacity = selectedPaymentDay != null ? 1.0 : 0.34;
        final buttonLabel = '${selectedPaymentDay?.day ?? 'Tap to select day'}';
        final _daySelectionDialog = DatePickerDialog(
          context: context,
          initialDate: selectedPaymentDay,
          daysSelectionLimit: AppConsts.lastSelectableSubscriptionDay,
        );

        return InkWell(
          onTap: () async {
            final date = await _daySelectionDialog.show();
            return model.onPaymentDayChange(date);
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
