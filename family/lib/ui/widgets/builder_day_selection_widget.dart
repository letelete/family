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
  })  : assert(context != null),
        assert(initialDate != null);

  Future<DateTime> show() async {
    final DateTime initialDate = this.initialDate ?? DateTime.now();
    final DateTime firstDate = this.firstDate ?? DateTime(initialDate.year - 1);
    final DateTime lastDate = this.firstDate ?? DateTime(initialDate.year + 1);
    return await showDatePicker(
      context: context,
      selectableDayPredicate: (DateTime val) {
        return daysSelectionLimit == null
            ? true
            : val.day <= daysSelectionLimit;
      },
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
