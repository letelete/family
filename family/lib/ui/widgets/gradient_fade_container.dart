import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/gradients.dart';
import 'package:flutter/cupertino.dart';

class GradientFadeContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget background;
  final Widget foreground;
  final Gradient gradient;

  const GradientFadeContainer({
    Key key,
    @required this.background,
    this.height,
    this.width,
    this.foreground,
    this.gradient,
  })  : assert(background != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = this.height ?? MediaQuery.of(context).size.height;
    final width = this.width ?? MediaQuery.of(context).size.width;
    final gradient = this.gradient ?? AppGradients.familyPhotoCover;

    Widget gradientWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(gradient: gradient),
    );

    return Container(
      height: height,
      width: width,
      color: AppColors.background,
      child: Stack(
        children: <Widget>[
          background,
          gradientWidget,
          if (foreground != null) foreground
        ],
      ),
    );
  }
}
