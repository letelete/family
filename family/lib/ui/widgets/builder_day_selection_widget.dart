import 'package:flutter/material.dart';

class BuilderDaySelection {
  final BuildContext context;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final int daysSelectionLimit;

  const BuilderDaySelection({
    @required this.context,
    @required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.daysSelectionLimit,
  }) : assert(context != null);

  Future<DateTime> show() async {
    var validInitialDate = this.initialDate ?? DateTime.now();
    bool initialDateBreaksPredicated =
        daysSelectionLimit != null && validInitialDate.day > daysSelectionLimit;
    if (initialDateBreaksPredicated) {
      validInitialDate = DateTime(
        validInitialDate.year,
        validInitialDate.month,
        validInitialDate.day - 1,
      );
    }
    final initialDate = validInitialDate;
    print(initialDate.toString());
    final firstDate = this.firstDate ?? DateTime(initialDate.year - 1);
    final lastDate = this.lastDate ?? DateTime(initialDate.year + 1);
    return await showDatePicker(
      context: context,
      selectableDayPredicate: (DateTime dt) =>
          (daysSelectionLimit == null || dt.day <= daysSelectionLimit),
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
  }
}
