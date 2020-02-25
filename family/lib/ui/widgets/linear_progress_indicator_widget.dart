import 'package:family/ui/shared/colors.dart';
import 'package:flutter/material.dart';

class LinearProgressIndicatorWidget extends StatelessWidget {
  const LinearProgressIndicatorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.black,
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
    );
  }
}
