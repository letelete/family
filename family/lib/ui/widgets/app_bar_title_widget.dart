import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle({Key key, this.title})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        this.title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: TextSizes.appBarTitle,
          fontWeight: FontWeight.w500,
        ),
      );
}
