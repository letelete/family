import 'package:family/ui/shared/colors.dart';
import 'package:flutter/material.dart';

class OverlappingAvatarsWidget extends StatelessWidget {
  static const _avatarBorderSize = 3.0;

  final List<Widget> avatars;
  final double singleAvatarSize;
  final double lappingShift;

  const OverlappingAvatarsWidget({
    Key key,
    this.avatars,
    this.singleAvatarSize,
  })  : this.lappingShift = singleAvatarSize * 0.2,
        assert(avatars != null),
        assert(avatars.length > 0),
        assert(singleAvatarSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: singleAvatarSize + 2 * _avatarBorderSize,
        width: _getWidgetWidth(),
        child: Stack(children: _getAvatars()),
      );

  double _getWidgetWidth() {
    double firstAvatar = singleAvatarSize;
    double allExceptFirst =
        (avatars.length - 1) * (singleAvatarSize - lappingShift);
    return firstAvatar + allExceptFirst;
  }

  List<Widget> _getAvatars() {
    double leftShift = -singleAvatarSize;
    int iterations = 0;
    return avatars
        .map((Widget avatar) {
          leftShift += singleAvatarSize;
          leftShift -= iterations * lappingShift;
          ++iterations;
          return _getOverlappingAvatar(avatar, leftShift);
        })
        .toList()
        .reversed
        .toList();
  }

  Widget _getOverlappingAvatar(
    Widget avatar,
    double leftShift,
  ) =>
      Positioned(
        left: leftShift,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(singleAvatarSize),
            border: Border.all(
              color: AppColors.background,
              width: _avatarBorderSize,
            ),
          ),
          child: avatar,
        ),
      );
}
