import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const MenuTile({
    Key key,
    this.title,
    this.onTap,
  })  : assert(title != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: this.onTap,
        child: Text(
          this.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: TextSizes.menuContent,
          ),
        ),
      );
}
