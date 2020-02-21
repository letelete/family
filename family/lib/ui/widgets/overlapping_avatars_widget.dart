import 'package:family/ui/shared/colors.dart';
import 'package:flutter/material.dart';

class OverlappingAvatarsWidget extends StatelessWidget {
  static const _avatarBorderSize = 3.0;

  final List<Widget> avatars;
  final double singleAvatarSize;

  final double _avatarOverlapPercentage;
  final double _totalAvatarSize;

  const OverlappingAvatarsWidget({
    Key key,
    this.avatars,
    this.singleAvatarSize,
  })  : assert(avatars != null),
        assert(avatars.length > 0),
        assert(singleAvatarSize != null),
        this._totalAvatarSize = singleAvatarSize + 2 * _avatarBorderSize,
        this._avatarOverlapPercentage = 0.2,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width;

    final double shiftDistance =
        _totalAvatarSize * (1.0 - _avatarOverlapPercentage);

    final double widgetSpace = _totalAvatarSize * avatars.length;
    final double marginSize = _totalAvatarSize * _avatarOverlapPercentage;
    final double marginsSpace = marginSize * (avatars.length - 1);
    final double widgetWidth = widgetSpace - marginsSpace;

    final int avatarsLimit = parentWidth ~/ shiftDistance - 1;

    int index = 0;
    List<Widget> avatarWidgets = avatars
        .take(avatarsLimit)
        .map((avatar) {
          double nextLeftPosition = shiftDistance * (index++);
          return _getOverlappingAvatar(avatar, nextLeftPosition);
        })
        .toList()
        .reversed
        .toList();

    return Container(
      height: _totalAvatarSize,
      width: widgetWidth,
      child: Stack(children: avatarWidgets),
    );
  }

  Widget _getOverlappingAvatar(
    Widget avatar,
    double leftPosition,
  ) =>
      Positioned(
        left: leftPosition,
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
