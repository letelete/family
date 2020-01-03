import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Circle user avatar filled with given photo url.\
///
/// If photo is null, or some error occured, avatar display
/// first [name] letter instead.
///
/// If [name] is null or empty, default avatar illustration is displayed.
class UserAvatarWidget extends StatelessWidget {
  final String photoUrl;
  final double size;
  final String name;
  final GestureTapCallback onTap;

  const UserAvatarWidget({
    Key key,
    this.photoUrl,
    this.size = 48.0,
    this.name,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          height: this.size,
          width: this.size,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: <Widget>[
              _getPlaceholder(),
              _getLetter(),
              _getImage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPlaceholder() => SvgPicture.asset(
        Assets.defaultUserAvatar,
        fit: BoxFit.cover,
        color: AppColors.primaryAccent,
      );

  Widget _getLetter() {
    if (this.name == null || this.name.isEmpty) return Container();

    return Center(
      child: Text(
        this.name[0],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: this.size * 0.6,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _getImage() {
    if (this.photoUrl == null || this.photoUrl.isEmpty) return Container();

    return ClipOval(
      child: Image.network(
        this.photoUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
